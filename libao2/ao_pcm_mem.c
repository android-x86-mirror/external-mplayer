/*
 * PCM audio output driver
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

#include "config.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "libavutil/common.h"
#include "mpbswap.h"
#include "subopt-helper.h"
#include "libaf/af_format.h"
#include "libaf/reorder_ch.h"
#include "audio_out.h"
#include "audio_out_internal.h"
#include "mp_msg.h"
#include "help_mp.h"

#ifdef __MINGW32__
// for GetFileType to detect pipes
#include <windows.h>
#endif

static const ao_info_t info =
{
    "RAW PCM/WAVE memory writer audio output",
    "pcm_mem",
    "merong",
    ""
};

LIBAO_EXTERN(pcm_mem)

extern int vo_pts;

static char *ao_outputbuffer = NULL;
static int ao_outputpos = -1;
static int ao_pcm_buffersize = -1;

/* init with default values */
static uint64_t data_length;

static void fput16le(uint16_t val, char * buffer, int pos) {
	uint8_t bytes[2] = {val, val >> 8};
	if (!ao_outputbuffer) {
		mp_msg(MSGT_AO, MSGL_INFO, "no buffer pointer");
		return;
	}
	if (ao_outputpos > ao_pcm_buffersize) {
		mp_msg(MSGT_AO, MSGL_INFO, "invalid output pos");
		return;
	}
	memcpy (buffer+ao_outputpos, bytes, 2);
	ao_outputpos += 2;
}

static void fput32le(uint32_t val, FILE *fp) {
    uint8_t bytes[4] = {val, val >> 8, val >> 16, val >> 24};
	if (!ao_outputbuffer) {
		mp_msg(MSGT_AO, MSGL_INFO, "no buffer pointer");
		return;
	}
	if (ao_outputpos > ao_pcm_buffersize) {
		mp_msg(MSGT_AO, MSGL_INFO, "invalid output pos");
		return;
	}
	memcpy (ao_outputbuffer+ao_outputpos, bytes, 4);
	ao_outputpos += 4;
}

// to set/get/query special features/parameters
static int control(int cmd,void *arg){
	switch (cmd) {
		case AOCONTROL_SET_DEVICE:
			mp_msg(MSGT_AO, MSGL_INFO, "set device %x\n", (int)arg);
			ao_outputbuffer = (char*)arg;
			ao_data.outburst = ao_pcm_buffersize;
			ao_data.buffersize = 0;
			ao_outputpos = 0;
			break;
		case AOCONTROL_SET_VOLUME:
			/* set the buffer size -_-; */
			mp_msg(MSGT_AO, MSGL_INFO, "set buffer size %d\n", (int)arg);
 			ao_pcm_buffersize = (int)arg;
			ao_data.outburst = ao_pcm_buffersize;
			ao_data.buffersize = 0;
			ao_outputpos = 0;
			break;
		case AOCONTROL_GET_DEVICE:
			mp_msg(MSGT_AO, MSGL_INFO, "get pos %d\n", (int)ao_outputpos);
			*(int*)arg = ao_outputpos;
			ao_outputpos = 0;
			break;
		default:
			break;
	}
}

// open & setup audio device
// return: 1=success 0=fail
static int init(int rate,int channels,int format,int flags){
    format = AF_FORMAT_S16_LE;

    ao_data.outburst = 0;
    ao_data.buffersize= 0;
    ao_data.channels=channels;
    ao_data.samplerate=rate;
    ao_data.format=format;
    ao_data.bps=channels*rate*(af_fmt2bits(format)/8);

	   mp_msg(MSGT_AO, MSGL_INFO, "%s rate%d %s %s\n",
			              "RAW PCM", rate,
						             (channels > 1) ? "Stereo" : "Mono", af_fmt2str_short(format));


    return 1;
}

// close audio device
static void uninit(int immed){

}

// stop playing and empty buffers (for seeking/pause)
static void reset(void){

}

// stop playing, keep buffers (for pause)
static void audio_pause(void)
{
    // for now, just call reset();
    reset();
}

// resume playing, after audio_pause()
static void audio_resume(void)
{
}

// return: how many bytes can be played without blocking
static int get_space(void){

    return ao_pcm_buffersize - ao_outputpos;
}

// plays 'len' bytes of 'data'
// it should round it down to outburst*n
// return: number of bytes played
static int play(void* data,int len,int flags){

    if (ao_data.channels == 5 || ao_data.channels == 6 || ao_data.channels == 8) {
        int frame_size = af_fmt2bits(ao_data.format) / 8;
        len -= len % (frame_size * ao_data.channels);
        reorder_channel_nch(data, AF_CHANNEL_LAYOUT_MPLAYER_DEFAULT,
                            AF_CHANNEL_LAYOUT_WAVEEX_DEFAULT,
                            ao_data.channels,
                            len / frame_size, frame_size);
    }

	if (ao_outputpos > ao_pcm_buffersize) {
		mp_msg (MSGT_AO, MSGL_INFO, "pcm output is bigger than memory buffer");
	}
	memcpy (ao_outputbuffer+ao_outputpos, data, len);
	ao_outputpos += len;

    return len;
}

// return: delay in seconds between first and last sample in buffer
static float get_delay(void){

    return 0.0;
}
