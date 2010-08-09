#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include "mplayer_lib.h"

int main (int argc, char*argv[])
{
	int fd;
	struct mplayer_context con;
	int argca;
	char * argva[30] = {"mplayer", "fd", "-vo", "null",
		"-ao", "pcm_mem", "-noconsolecontrols", "-nojoystick",
		"-nolirc", "-nomouseinput", "-slave", "-zoom",
		"-fs", "-msglevel", "all=9",
		0};
	char url_buffer[100];
	char audio_buffer[4096];
	int mresult;

	fd = open (argv[1], O_RDWR);
	sprintf (url_buffer, "fd://%d", fd);
	argva[1] = url_buffer;
	for (argca=0; argca<30; argca++) {
		if (argva[argca] == 0)
			break;
	}
	mresult = mplayer_init(&con, argc, argv);
	mresult = mplayer_prepare_play (&con);

	while (1) {
		int audio_pos;
		unsigned int decoded_frames;
		mresult = mplayer_decode_audio (&con, audio_buffer, 4096, &audio_pos);
		printf ("mresult decode_audio %d %x %x %x %x %x\n", mresult,
				audio_buffer[0],
				audio_buffer[1],
				audio_buffer[2],
				audio_buffer[3],
				audio_buffer[4]);
		if (mresult) break;

		mresult = mplayer_decode_video(&con, NULL, &decoded_frames);
		printf ("mresult decode_video %d\n", mresult);
		if (mresult) break;

		mresult = mplayer_after_decode(&con);
		printf ("mresult after_decode %d\n", mresult);
		if (mresult) break;
	}
	mplayer_close(&con);

	return 0;
}


