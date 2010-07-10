/*
 * video driver for framebuffer device
 * copyright (C) 2001 Szabolcs Berecz <szabi@inf.elte.hu>
 *
 * Some idea and code borrowed from Chris Lawrence's ppmtofb-0.27
 * Some fixes and small improvements by Joey Parrish <joey@nicewarrior.org>
 *
 * This file is part of MPlayer.
 *
 * MPlayer is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * MPlayer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with MPlayer; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <ctype.h>

#include <sys/mman.h>
#include <sys/ioctl.h>
#include <sys/kd.h>
#include <linux/fb.h>

#include "config.h"
#include "video_out.h"
#include "video_out_internal.h"
#include "fastmemcpy.h"
#include "sub.h"
#include "geometry.h"
#include "aspect.h"
#include "libavutil/common.h"

static const vo_info_t info = {
    "memory buffer device"
    "mem",
    "okkwon <pinebud@gmail.com> modified"
    ""
};

LIBVO_EXTERN(fbdev)

static signed int pre_init_err = -2;

static char * buffer = NULL;
static size_t buffer_size = 0;
static uint8_t *center;
static int mem_bpp;              // 32: 32  24: 24  16: 16  15: 15
static int mem_pixel_size;
static int mem_line_len;
static int mem_xres;
static int mem_yres;
static int in_width;
static int in_height;
static int out_width;
static int out_height;
static int first_row;
static int last_row;
static uint32_t pixel_format;
static int fs;


static int config(uint32_t width, uint32_t height, uint32_t d_width,
                  uint32_t d_height, uint32_t flags, char *title,
                  uint32_t format)
{
    int zoom = flags & VOFLAG_SWSCALE;
    fs = flags & VOFLAG_FULLSCREEN;

    if (pre_init_err == -2) {
        mp_msg(MSGT_VO, MSGL_ERR, "Internal fatal error: config() was called before preinit()\n");
        return -1;
    }

    if (pre_init_err)
        return 1;

    if (d_width && (fs || zoom)) {
        out_width  = d_width;
        out_height = d_height;
    } else {
        out_width  = width;
        out_height = height;
    }
    in_width     = width;
    in_height    = height;
    pixel_format = format;

    mem_pixel_size = fb_vinfo.bits_per_pixel / 8;
    fb_bpp = fb_vinfo.bits_per_pixel;

    switch (fb_bpp) {
    case 32:
        draw_alpha_p = vo_draw_alpha_rgb32;
        break;
    case 24:
        draw_alpha_p = vo_draw_alpha_rgb24;
        break;
    case 16:
        draw_alpha_p = vo_draw_alpha_rgb16;
        break;
    case 15:
        draw_alpha_p = vo_draw_alpha_rgb15;
        break;
    case 12:
        draw_alpha_p = vo_draw_alpha_rgb12;
        break;
    default:
        return 1;
    }

    fb_xres = fb_vinfo.xres;
    fb_yres = fb_vinfo.yres;

    if (vm || fs) {
        out_width  = fb_xres;
        out_height = fb_yres;
    }

    first_row = (out_height - in_height) / 2;
    last_row  = (out_height + in_height) / 2;
    fb_line_len = fb_finfo.line_length;
    {
        int x_offset = 0, y_offset = 0;
        geometry(&x_offset, &y_offset, &out_width, &out_height, fb_xres, fb_yres);

        frame_buffer = mmap(0, fb_size, PROT_READ | PROT_WRITE,
                            MAP_SHARED, fb_dev_fd, 0);
        if (frame_buffer == (uint8_t *) -1) {
            mp_msg(MSGT_VO, MSGL_ERR, "Can't mmap %s: %s\n", fb_dev_name, strerror(errno));
            return 1;
        }

        center = frame_buffer +
                 ( (out_width  - in_width)  / 2 ) * fb_pixel_size +
                 ( (out_height - in_height) / 2 ) * fb_line_len +
                 x_offset * fb_pixel_size + y_offset * fb_line_len +
                 fb_page * fb_yres * fb_line_len;

        mp_msg(MSGT_VO, MSGL_DBG2, "buffer @ %p\n", buffer);
        mp_msg(MSGT_VO, MSGL_DBG2, "center @ %p\n", center);
        mp_msg(MSGT_VO, MSGL_V, "pixel per line: %d\n", fb_line_len / fb_pixel_size);

        if (fs || vm) {
            int clear_size = fb_line_len * fb_yres;
            if (vo_doublebuffering)
                clear_size <<= 1;
            memset(frame_buffer, 0, clear_size);
        }
    }

    return 0;
}

static int query_format(uint32_t format)
{
    if (!fb_preinit(0))
        return 0;
    if ((format & IMGFMT_BGR_MASK) == IMGFMT_BGR) {
        int bpp = format & 0xff;

        if (bpp == fb_bpp)
            return VFCAP_ACCEPT_STRIDE | VFCAP_CSP_SUPPORTED | VFCAP_CSP_SUPPORTED_BY_HW;
    }
    return 0;
}

static void draw_alpha(int x0, int y0, int w, int h, unsigned char *src,
                       unsigned char *srca, int stride)
{
    unsigned char *dst;

    dst = center + fb_line_len * y0 + fb_pixel_size * x0;

    (*draw_alpha_p)(w, h, src, srca, stride, dst, fb_line_len);
}

static int draw_frame(uint8_t *src[])
{
    return 1;
}

static int draw_slice(uint8_t *src[], int stride[], int w, int h, int x, int y)
{
    uint8_t *d;

    d = center + fb_line_len * y + fb_pixel_size * x;

    memcpy_pic2(d, src[0], w * fb_pixel_size, h, fb_line_len, stride[0], 1);

    return 0;
}

static void check_events(void)
{
}

static void flip_page(void)
{
	/* we don't flip_page */
}

static void draw_osd(void)
{
    vo_draw_text(in_width, in_height, draw_alpha);
}

static void uninit(void)
{
    fb_preinit(1);
}

static int preinit(const char *vo_subdevice)
{
    pre_init_err = 0;

    if (!pre_init_err)
        return pre_init_err = fb_preinit(0) ? 0 : -1;
    return -1;
}

static uint32_t get_image(mp_image_t *mpi)
{
    if (!IMGFMT_IS_BGR(mpi->imgfmt) ||
        IMGFMT_BGR_DEPTH(mpi->imgfmt) != fb_bpp ||
        (mpi->type != MP_IMGTYPE_STATIC && mpi->type != MP_IMGTYPE_TEMP) ||
        (mpi->flags & MP_IMGFLAG_PLANAR) ||
        (mpi->flags & MP_IMGFLAG_YUV) ||
        mpi->width != in_width ||
        mpi->height != in_height
       )
        return VO_FALSE;

    mpi->planes[0] = center;
    mpi->stride[0] = fb_line_len;
    mpi->flags    |= MP_IMGFLAG_DIRECT;
    return VO_TRUE;
}

static int control(uint32_t request, void *data, ...)
{
    switch (request) {
    case VOCTRL_GET_IMAGE:
        return get_image(data);
    case VOCTRL_QUERY_FORMAT:
        return query_format(*(uint32_t*)data);
    }
    return VO_NOTIMPL;
}
