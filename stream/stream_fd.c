/*
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
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

#include "mp_msg.h"
#include "stream.h"
#include "help_mp.h"
#include "m_option.h"
#include "m_struct.h"

static int fill_buffer(stream_t *s, char* buffer, int max_len){
  int r = read(s->fd,buffer,max_len);
  if (r<=0) {
    mp_msg(MSGT_STREAM,MSGL_INFO,"fill_buffer failed with fd%d buffer%x max_len%x errno%d\n",
		   	s->fd, buffer, max_len, errno);
  }

  return (r <= 0) ? -1 : r;
}

static int write_buffer(stream_t *s, char* buffer, int len) {
  int r = write(s->fd,buffer,len);
  return (r <= 0) ? -1 : r;
}

static int seek(stream_t *s,off_t newpos) {
  s->pos = newpos;
  if(lseek(s->fd,s->pos,SEEK_SET)<0) {
    mp_msg(MSGT_STREAM,MSGL_INFO,"seek failed errno %d\n", errno);
    s->eof=1;
    return 0;
  }
  return 1;
}

static int seek_forward(stream_t *s,off_t newpos) {
  if(newpos<s->pos){
    mp_msg(MSGT_STREAM,MSGL_INFO,"Cannot seek backward in linear streams!\n");
    return 0;
  }
  while(s->pos<newpos){
    int len=s->fill_buffer(s,s->buffer,STREAM_BUFFER_SIZE);
    if(len<=0){ s->eof=1; s->buf_pos=s->buf_len=0; break; } // EOF
    s->buf_pos=0;
    s->buf_len=len;
    s->pos+=len;
  }
  return 1;
}

static int control(stream_t *s, int cmd, void *arg) {
  switch(cmd) {
    case STREAM_CTRL_GET_SIZE: {
      off_t size;

      size = lseek(s->fd, 0, SEEK_END);
      lseek(s->fd, s->pos, SEEK_SET);
      if(size != (off_t)-1) {
        *((off_t*)arg) = size;
        return 1;
      }
    }
  }
  return STREAM_UNSUPPORTED;
}

static int open_f(stream_t *stream,int mode, void* opts, int* file_format) {
	int f;
	off_t len;

	mp_msg(MSGT_OPEN,MSGL_INFO,"filename %s\n", stream->url);
	sscanf (stream->url, "fd://%d", &f);
	if (f < 0)
		return STREAM_UNSUPPORTED;

	len=lseek(f,0,SEEK_END); lseek(f,0,SEEK_SET);
	if(len == -1) {
		mp_msg(MSGT_OPEN,MSGL_V,"fd type stream");
		if(mode == STREAM_READ) stream->seek = seek_forward;
		stream->type = STREAMTYPE_STREAM; // Must be move to STREAMTYPE_FILE
		stream->flags |= MP_STREAM_SEEK_FW;
	} else if(len >= 0) {
		mp_msg(MSGT_OPEN,MSGL_V,"fd type file");
		stream->seek = seek;
		stream->end_pos = len;
		stream->type = STREAMTYPE_FILE;
	}
	mp_msg(MSGT_OPEN,MSGL_V,"[file] File size is %"PRId64" bytes\n", (int64_t)len);

	stream->fd = f;
	stream->fill_buffer = fill_buffer;
	stream->write_buffer = write_buffer;
	stream->control = control;

	return STREAM_OK;
}

const stream_info_t stream_info_filefd = {
  "File Descriptor",
  "fd",
  "okkwon <pinebud@gmail.com>",
  "based on the code from file stream (probably Arpi)",
  open_f,
  { "fd", NULL },
  NULL,
  0 // Urls are an option string
};
