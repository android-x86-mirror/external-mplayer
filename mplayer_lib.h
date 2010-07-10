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
};

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
