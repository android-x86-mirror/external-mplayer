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
    "okkwon <pinebud@gmail.com>",
    "based on pcm and null ao"
};

LIBAO_EXTERN(pcm_mem)

struct timeval last_tv;
int buffer;

extern int vo_pts;
static char *ao_outputbuffer = NULL;
static int ao_outputpos = -1;
static int ao_pcm_buffersize = -1;

/* init with default values */
static uint64_t data_length;

static void drain (void) {
	struct timeval now_tv;
	int temp, temp2;

	if (last_tv.tv_sec == 0 && last_tv.tv_usec == 0) 
		gettimeofday(&last_tv, 0);

	gettimeofday(&now_tv, 0);
	temp = now_tv.tv_sec - last_tv.tv_sec;
	temp *= ao_data.bps;

	temp2 = now_tv.tv_usec - last_tv.tv_usec;
	temp2 /= 1000;
	temp2 *= ao_data.bps;
	temp2 /= 1000;
	temp += temp2;

	temp *= 1.03;
	mp_msg(MSGT_AO, MSGL_INFO, "temp %d", temp);

	buffer-=temp;
	if (buffer<0){
		mp_msg(MSGT_AO, MSGL_INFO, "calculated buffer smaller than 0");
	   	buffer=0;
	}

	if(temp>0) last_tv = now_tv;//mplayer is fast

	/* test : round the buffer size */
}

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
			ao_outputbuffer = (char*)arg;
			ao_outputpos = 0;
			break;
		case AOCONTROL_SET_VOLUME:
			/* set the buffer size -_-; */
 			ao_pcm_buffersize = (int)arg;
			ao_outputpos = 0;
			break;
		case AOCONTROL_GET_DEVICE:
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
	int samplesize = af_fmt2bits(format) / 8;

	ao_data.outburst = 256 * channels * samplesize;
	// A "buffer" for about 0.3 seconds of audio
	ao_data.buffersize = (int)(rate * 0.2 / 256 + 1) * ao_data.outburst;
	ao_data.channels=channels;
	ao_data.samplerate=rate;
	ao_data.format=format;
	ao_data.bps=channels*rate*samplesize;
	buffer = 0;

	last_tv.tv_sec = 0;
	last_tv.tv_usec = 0;

	mp_msg(MSGT_AO, MSGL_INFO, "%s rate%d %s %s\n",
			"RAW PCM", rate,
			(channels > 1) ? "Stereo" : "Mono", af_fmt2str_short(format));
	mp_msg(MSGT_AO, MSGL_INFO, "outburst %d, buffersize %d", 
			ao_data.outburst, ao_data.buffersize);
	mp_msg(MSGT_AO, MSGL_INFO, "bps %d", ao_data.bps);

	return 1;
}

// close audio device
static void uninit(int immed){

}

// stop playing and empty buffers (for seeking/pause)
static void reset(void){
	buffer = 0;

	last_tv.tv_sec = 0;
	last_tv.tv_usec = 0;
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
	int virt_space;
	int real_space;
	drain();
	virt_space = ao_data.buffersize - buffer;
	real_space = ao_pcm_buffersize - ao_outputpos;
	if (virt_space > real_space) return real_space;
	else return virt_space;
}

// plays 'len' bytes of 'data'
// it should round it down to outburst*n
// return: number of bytes played
static int play(void* data,int len,int flags){
	int maxbursts = (ao_data.buffersize - buffer) / ao_data.outburst;
	int playbursts = len / ao_data.outburst;
	int bursts = playbursts > maxbursts ? maxbursts : playbursts;
	buffer += bursts * ao_data.outburst;

	if (ao_data.channels == 5 || ao_data.channels == 6 || 
			ao_data.channels == 8) {
		int frame_size = af_fmt2bits(ao_data.format) / 8;
		len -= len % (frame_size * ao_data.channels);
		reorder_channel_nch(data, AF_CHANNEL_LAYOUT_MPLAYER_DEFAULT,
				AF_CHANNEL_LAYOUT_WAVEEX_DEFAULT,
				ao_data.channels,
				len / frame_size, frame_size);
	}

	memcpy (ao_outputbuffer+ao_outputpos, data, bursts * ao_data.outburst);
	ao_outputpos += bursts * ao_data.outburst;

	if (ao_outputpos > ao_pcm_buffersize) {
		mp_msg (MSGT_AO, MSGL_INFO, "pcm output is bigger than memory buffer");
	}

	return bursts * ao_data.outburst;
}

// return: delay in seconds between first and last sample in buffer
static float get_delay(void){
	drain();
	return (float) buffer / (float) ao_data.bps;
}
