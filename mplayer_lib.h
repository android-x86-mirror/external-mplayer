#ifndef _MPLAYER_LIB_H
#define _MPLAYER_LIB_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

struct mplayer_context {
	float aq_sleep_time;
	int blit_frame;
	int frame_time_remaining;
	double a_pos;
};

extern int mplayer_get_video_size(struct mplayer_context * con,
		int *width, int *height);
extern int mplayer_seek (struct mplayer_context * con, int position);
extern int mplayer_get_pos (struct mplayer_context *con, int*v_pos);
extern int mplayer_get_duration (struct mplayer_context *con, int*duration);
extern int mplayer_get_audio_info(struct mplayer_context *con, uint32_t *samp, int*chc);
extern int mplayer_init (struct mplayer_context *con, int argc, char *argv[]);
extern int mplayer_decode_audio (struct mplayer_context *con, char * buffer,
		int buffer_size, int * read_size);
extern int mplayer_decode_video (struct mplayer_context * con, char * buffer);
extern int mplayer_after_decode (struct mplayer_context * con);
extern int mplayer_close(struct mplayer_context *con);

#ifdef __cplusplus
}
#endif

#endif
