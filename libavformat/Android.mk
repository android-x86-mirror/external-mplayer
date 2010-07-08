LOCAL_PATH := $(call my-dir)
include  $(LOCAL_PATH)/../preconfig_x86_mmx_sse.mak

AVFORMAT_FILES-yes = allformats.c         \
	   cutils.c             \
	   metadata.c           \
	   metadata_compat.c    \
	   options.c            \
	   os_support.c         \
	   sdp.c                \
	   seek.c               \
	   utils.c              

AVFORMAT_FILES-$(CONFIG_AAC_DEMUXER)               += raw.c id3v1.c id3v2.c
AVFORMAT_FILES-$(CONFIG_AC3_DEMUXER)               += raw.c
AVFORMAT_FILES-$(CONFIG_AC3_MUXER)                 += raw.c
AVFORMAT_FILES-$(CONFIG_ADTS_MUXER)                += adtsenc.c
AVFORMAT_FILES-$(CONFIG_AEA_DEMUXER)               += aea.c raw.c
AVFORMAT_FILES-$(CONFIG_AIFF_DEMUXER)              += aiffdec.c riff.c raw.c
AVFORMAT_FILES-$(CONFIG_AIFF_MUXER)                += aiffenc.c riff.c
AVFORMAT_FILES-$(CONFIG_AMR_DEMUXER)               += amr.c
AVFORMAT_FILES-$(CONFIG_AMR_MUXER)                 += amr.c
AVFORMAT_FILES-$(CONFIG_ANM_DEMUXER)               += anm.c
AVFORMAT_FILES-$(CONFIG_APC_DEMUXER)               += apc.c
AVFORMAT_FILES-$(CONFIG_APE_DEMUXER)               += ape.c apetag.c
AVFORMAT_FILES-$(CONFIG_ASF_DEMUXER)               += asfdec.c asf.c asfcrypt.c \
	riff.c avlanguage.c
AVFORMAT_FILES-$(CONFIG_ASF_MUXER)                 += asfenc.c asf.c riff.c
AVFORMAT_FILES-$(CONFIG_ASS_DEMUXER)               += assdec.c
AVFORMAT_FILES-$(CONFIG_ASS_MUXER)                 += assenc.c
AVFORMAT_FILES-$(CONFIG_AU_DEMUXER)                += au.c raw.c
AVFORMAT_FILES-$(CONFIG_AU_MUXER)                  += au.c
AVFORMAT_FILES-$(CONFIG_AVI_DEMUXER)               += avidec.c riff.c avi.c
AVFORMAT_FILES-$(CONFIG_AVI_MUXER)                 += avienc.c riff.c avi.c
AVFORMAT_FILES-$(CONFIG_AVISYNTH)                  += avisynth.c
AVFORMAT_FILES-$(CONFIG_AVM2_MUXER)                += swfenc.c
AVFORMAT_FILES-$(CONFIG_AVS_DEMUXER)               += avs.c vocdec.c voc.c
AVFORMAT_FILES-$(CONFIG_BETHSOFTVID_DEMUXER)       += bethsoftvid.c
AVFORMAT_FILES-$(CONFIG_BFI_DEMUXER)               += bfi.c
AVFORMAT_FILES-$(CONFIG_BINK_DEMUXER)              += bink.c
AVFORMAT_FILES-$(CONFIG_C93_DEMUXER)               += c93.c vocdec.c voc.c
AVFORMAT_FILES-$(CONFIG_CAF_DEMUXER)               += cafdec.c caf.c mov.c riff.c isom.c
AVFORMAT_FILES-$(CONFIG_CAVSVIDEO_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_CDG_DEMUXER)               += cdg.c
AVFORMAT_FILES-$(CONFIG_CRC_MUXER)                 += crcenc.c
AVFORMAT_FILES-$(CONFIG_DAUD_DEMUXER)              += daud.c
AVFORMAT_FILES-$(CONFIG_DAUD_MUXER)                += daud.c
AVFORMAT_FILES-$(CONFIG_DIRAC_DEMUXER)             += raw.c
AVFORMAT_FILES-$(CONFIG_DIRAC_MUXER)               += raw.c
AVFORMAT_FILES-$(CONFIG_DNXHD_DEMUXER)             += raw.c
AVFORMAT_FILES-$(CONFIG_DNXHD_MUXER)               += raw.c
AVFORMAT_FILES-$(CONFIG_DSICIN_DEMUXER)            += dsicin.c
AVFORMAT_FILES-$(CONFIG_DTS_DEMUXER)               += raw.c
AVFORMAT_FILES-$(CONFIG_DTS_MUXER)                 += raw.c
AVFORMAT_FILES-$(CONFIG_DV_DEMUXER)                += dv.c
AVFORMAT_FILES-$(CONFIG_DV_MUXER)                  += dvenc.c
AVFORMAT_FILES-$(CONFIG_DXA_DEMUXER)               += dxa.c riff.c
AVFORMAT_FILES-$(CONFIG_EA_CDATA_DEMUXER)          += eacdata.c
AVFORMAT_FILES-$(CONFIG_EA_DEMUXER)                += electronicarts.c
AVFORMAT_FILES-$(CONFIG_EAC3_DEMUXER)              += raw.c
AVFORMAT_FILES-$(CONFIG_EAC3_MUXER)                += raw.c
AVFORMAT_FILES-$(CONFIG_FFM_DEMUXER)               += ffmdec.c
AVFORMAT_FILES-$(CONFIG_FFM_MUXER)                 += ffmenc.c
AVFORMAT_FILES-$(CONFIG_FILMSTRIP_DEMUXER)         += filmstripdec.c
AVFORMAT_FILES-$(CONFIG_FILMSTRIP_MUXER)           += filmstripenc.c
AVFORMAT_FILES-$(CONFIG_FLAC_DEMUXER)              += flacdec.c raw.c id3v1.c \
	id3v2.c oggparsevorbis.c \
	vorbiscomment.c
AVFORMAT_FILES-$(CONFIG_FLAC_MUXER)                += flacenc.c flacenc_header.c \
	vorbiscomment.c
AVFORMAT_FILES-$(CONFIG_FLIC_DEMUXER)              += flic.c
AVFORMAT_FILES-$(CONFIG_FLV_DEMUXER)               += flvdec.c
AVFORMAT_FILES-$(CONFIG_FLV_MUXER)                 += flvenc.c avc.c
AVFORMAT_FILES-$(CONFIG_FOURXM_DEMUXER)            += 4xm.c
AVFORMAT_FILES-$(CONFIG_FRAMECRC_MUXER)            += framecrcenc.c
AVFORMAT_FILES-$(CONFIG_FRAMEMD5_MUXER)            += md5enc.c
AVFORMAT_FILES-$(CONFIG_GIF_MUXER)                 += gif.c
AVFORMAT_FILES-$(CONFIG_GSM_DEMUXER)               += raw.c
AVFORMAT_FILES-$(CONFIG_GXF_DEMUXER)               += gxf.c
AVFORMAT_FILES-$(CONFIG_GXF_MUXER)                 += gxfenc.c audiointerleave.c
AVFORMAT_FILES-$(CONFIG_H261_DEMUXER)              += raw.c
AVFORMAT_FILES-$(CONFIG_H261_MUXER)                += raw.c
AVFORMAT_FILES-$(CONFIG_H263_DEMUXER)              += raw.c
AVFORMAT_FILES-$(CONFIG_H263_MUXER)                += raw.c
AVFORMAT_FILES-$(CONFIG_H264_DEMUXER)              += raw.c
AVFORMAT_FILES-$(CONFIG_H264_MUXER)                += raw.c
AVFORMAT_FILES-$(CONFIG_IDCIN_DEMUXER)             += idcin.c
AVFORMAT_FILES-$(CONFIG_IFF_DEMUXER)               += iff.c
AVFORMAT_FILES-$(CONFIG_IMAGE2_DEMUXER)            += img2.c
AVFORMAT_FILES-$(CONFIG_IMAGE2_MUXER)              += img2.c
AVFORMAT_FILES-$(CONFIG_IMAGE2PIPE_DEMUXER)        += img2.c
AVFORMAT_FILES-$(CONFIG_IMAGE2PIPE_MUXER)          += img2.c
AVFORMAT_FILES-$(CONFIG_INGENIENT_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_IPMOVIE_DEMUXER)           += ipmovie.c
AVFORMAT_FILES-$(CONFIG_ISS_DEMUXER)               += iss.c
AVFORMAT_FILES-$(CONFIG_IV8_DEMUXER)               += iv8.c
AVFORMAT_FILES-$(CONFIG_IVF_DEMUXER)               += ivfdec.c riff.c
AVFORMAT_FILES-$(CONFIG_LMLM4_DEMUXER)             += lmlm4.c
AVFORMAT_FILES-$(CONFIG_M4V_DEMUXER)               += raw.c
AVFORMAT_FILES-$(CONFIG_M4V_MUXER)                 += raw.c
AVFORMAT_FILES-$(CONFIG_MATROSKA_DEMUXER)          += matroskadec.c matroska.c \
	riff.c isom.c rmdec.c rm.c
AVFORMAT_FILES-$(CONFIG_MATROSKA_MUXER)            += matroskaenc.c matroska.c \
	riff.c isom.c avc.c \
	flacenc_header.c
AVFORMAT_FILES-$(CONFIG_MD5_MUXER)                 += md5enc.c
AVFORMAT_FILES-$(CONFIG_MJPEG_DEMUXER)             += raw.c
AVFORMAT_FILES-$(CONFIG_MJPEG_MUXER)               += raw.c
AVFORMAT_FILES-$(CONFIG_MLP_DEMUXER)               += raw.c
AVFORMAT_FILES-$(CONFIG_MLP_MUXER)                 += raw.c
AVFORMAT_FILES-$(CONFIG_MM_DEMUXER)                += mm.c
AVFORMAT_FILES-$(CONFIG_MMF_DEMUXER)               += mmf.c raw.c
AVFORMAT_FILES-$(CONFIG_MMF_MUXER)                 += mmf.c riff.c
AVFORMAT_FILES-$(CONFIG_MOV_DEMUXER)               += mov.c riff.c isom.c
AVFORMAT_FILES-$(CONFIG_MOV_MUXER)                 += movenc.c riff.c isom.c avc.c movenchint.c
AVFORMAT_FILES-$(CONFIG_MP2_MUXER)                 += mp3.c id3v1.c
AVFORMAT_FILES-$(CONFIG_MP3_DEMUXER)               += mp3.c id3v1.c id3v2.c
AVFORMAT_FILES-$(CONFIG_MP3_MUXER)                 += mp3.c id3v1.c id3v2.c
AVFORMAT_FILES-$(CONFIG_MPC_DEMUXER)               += mpc.c id3v1.c id3v2.c apetag.c
AVFORMAT_FILES-$(CONFIG_MPC8_DEMUXER)              += mpc8.c
AVFORMAT_FILES-$(CONFIG_MPEG1SYSTEM_MUXER)         += mpegenc.c
AVFORMAT_FILES-$(CONFIG_MPEG1VCD_MUXER)            += mpegenc.c
AVFORMAT_FILES-$(CONFIG_MPEG2DVD_MUXER)            += mpegenc.c
AVFORMAT_FILES-$(CONFIG_MPEG2VOB_MUXER)            += mpegenc.c
AVFORMAT_FILES-$(CONFIG_MPEG2SVCD_MUXER)           += mpegenc.c
AVFORMAT_FILES-$(CONFIG_MPEG1VIDEO_MUXER)          += raw.c
AVFORMAT_FILES-$(CONFIG_MPEG2VIDEO_MUXER)          += raw.c
AVFORMAT_FILES-$(CONFIG_MPEGPS_DEMUXER)            += mpeg.c
AVFORMAT_FILES-$(CONFIG_MPEGTS_DEMUXER)            += mpegts.c
AVFORMAT_FILES-$(CONFIG_MPEGTS_MUXER)              += mpegtsenc.c adtsenc.c
AVFORMAT_FILES-$(CONFIG_MPEGVIDEO_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_MPJPEG_MUXER)              += mpjpeg.c
AVFORMAT_FILES-$(CONFIG_MSNWC_TCP_DEMUXER)         += msnwc_tcp.c
AVFORMAT_FILES-$(CONFIG_MTV_DEMUXER)               += mtv.c
AVFORMAT_FILES-$(CONFIG_MVI_DEMUXER)               += mvi.c
AVFORMAT_FILES-$(CONFIG_MXF_DEMUXER)               += mxfdec.c mxf.c
AVFORMAT_FILES-$(CONFIG_MXF_MUXER)                 += mxfenc.c mxf.c audiointerleave.c
AVFORMAT_FILES-$(CONFIG_NC_DEMUXER)                += ncdec.c
AVFORMAT_FILES-$(CONFIG_NSV_DEMUXER)               += nsvdec.c
AVFORMAT_FILES-$(CONFIG_NULL_MUXER)                += raw.c
AVFORMAT_FILES-$(CONFIG_NUT_DEMUXER)               += nutdec.c nut.c riff.c
AVFORMAT_FILES-$(CONFIG_NUT_MUXER)                 += nutenc.c nut.c riff.c
AVFORMAT_FILES-$(CONFIG_NUV_DEMUXER)               += nuv.c riff.c
AVFORMAT_FILES-$(CONFIG_OGG_DEMUXER)               += oggdec.c         \
	oggparsedirac.c  \
	oggparseflac.c   \
	oggparseogm.c    \
	oggparseskeleton.c \
	oggparsespeex.c  \
	oggparsetheora.c \
	oggparsevorbis.c \
	riff.c \
	vorbiscomment.c
AVFORMAT_FILES-$(CONFIG_OGG_MUXER)                 += oggenc.c \
	vorbiscomment.c
AVFORMAT_FILES-$(CONFIG_OMA_DEMUXER)               += oma.c raw.c id3v2.c id3v1.c
AVFORMAT_FILES-$(CONFIG_PCM_ALAW_DEMUXER)          += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_ALAW_MUXER)            += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_F32BE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_F32BE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_F32LE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_F32LE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_F64BE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_F64BE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_F64LE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_F64LE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_MULAW_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_MULAW_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S16BE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S16BE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S16LE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S16LE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S24BE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S24BE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S24LE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S24LE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S32BE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S32BE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S32LE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S32LE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S8_DEMUXER)            += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_S8_MUXER)              += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U16BE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U16BE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U16LE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U16LE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U24BE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U24BE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U24LE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U24LE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U32BE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U32BE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U32LE_DEMUXER)         += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U32LE_MUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U8_DEMUXER)            += raw.c
AVFORMAT_FILES-$(CONFIG_PCM_U8_MUXER)              += raw.c
AVFORMAT_FILES-$(CONFIG_PVA_DEMUXER)               += pva.c
AVFORMAT_FILES-$(CONFIG_QCP_DEMUXER)               += qcp.c
AVFORMAT_FILES-$(CONFIG_R3D_DEMUXER)               += r3d.c
AVFORMAT_FILES-$(CONFIG_RAWVIDEO_DEMUXER)          += raw.c
AVFORMAT_FILES-$(CONFIG_RAWVIDEO_MUXER)            += raw.c
AVFORMAT_FILES-$(CONFIG_RL2_DEMUXER)               += rl2.c
AVFORMAT_FILES-$(CONFIG_RM_DEMUXER)                += rmdec.c rm.c
AVFORMAT_FILES-$(CONFIG_RM_MUXER)                  += rmenc.c rm.c
AVFORMAT_FILES-$(CONFIG_ROQ_DEMUXER)               += idroq.c
AVFORMAT_FILES-$(CONFIG_ROQ_MUXER)                 += raw.c
AVFORMAT_FILES-$(CONFIG_RPL_DEMUXER)               += rpl.c
AVFORMAT_FILES-$(CONFIG_RTP_MUXER)                 += rtp.c         \
	rtpenc_aac.c     \
	rtpenc_amr.c     \
	rtpenc_h263.c    \
	rtpenc_mpv.c     \
	rtpenc.c      \
	rtpenc_h264.c \
	avc.c
AVFORMAT_FILES-$(CONFIG_RTSP_DEMUXER)              += rtsp.c httpauth.c
AVFORMAT_FILES-$(CONFIG_RTSP_MUXER)                += rtsp.c rtspenc.c httpauth.c
AVFORMAT_FILES-$(CONFIG_SDP_DEMUXER)               += rtsp.c        \
	rdt.c         \
	rtp.c         \
	rtpdec.c      \
	rtpdec_amr.c  \
	rtpdec_asf.c  \
	rtpdec_h263.c \
	rtpdec_h264.c \
	rtpdec_mpeg4.c \
	rtpdec_svq3.c \
	rtpdec_xiph.c
AVFORMAT_FILES-$(CONFIG_SEGAFILM_DEMUXER)          += segafilm.c
AVFORMAT_FILES-$(CONFIG_SHORTEN_DEMUXER)           += raw.c
AVFORMAT_FILES-$(CONFIG_SIFF_DEMUXER)              += siff.c
AVFORMAT_FILES-$(CONFIG_SMACKER_DEMUXER)           += smacker.c
AVFORMAT_FILES-$(CONFIG_SOL_DEMUXER)               += sol.c raw.c
AVFORMAT_FILES-$(CONFIG_SOX_DEMUXER)               += soxdec.c raw.c
AVFORMAT_FILES-$(CONFIG_SOX_MUXER)                 += soxenc.c
AVFORMAT_FILES-$(CONFIG_SPDIF_MUXER)               += spdif.c
AVFORMAT_FILES-$(CONFIG_STR_DEMUXER)               += psxstr.c
AVFORMAT_FILES-$(CONFIG_SWF_DEMUXER)               += swfdec.c
AVFORMAT_FILES-$(CONFIG_SWF_MUXER)                 += swfenc.c
AVFORMAT_FILES-$(CONFIG_THP_DEMUXER)               += thp.c
AVFORMAT_FILES-$(CONFIG_TIERTEXSEQ_DEMUXER)        += tiertexseq.c
AVFORMAT_FILES-$(CONFIG_TMV_DEMUXER)               += tmv.c
AVFORMAT_FILES-$(CONFIG_TRUEHD_DEMUXER)            += raw.c
AVFORMAT_FILES-$(CONFIG_TRUEHD_MUXER)              += raw.c
AVFORMAT_FILES-$(CONFIG_TTA_DEMUXER)               += tta.c id3v1.c id3v2.c
AVFORMAT_FILES-$(CONFIG_TXD_DEMUXER)               += txd.c
AVFORMAT_FILES-$(CONFIG_VC1_DEMUXER)               += raw.c
AVFORMAT_FILES-$(CONFIG_VC1T_DEMUXER)              += vc1test.c
AVFORMAT_FILES-$(CONFIG_VC1T_MUXER)                += vc1testenc.c
AVFORMAT_FILES-$(CONFIG_VMD_DEMUXER)               += sierravmd.c
AVFORMAT_FILES-$(CONFIG_VOC_DEMUXER)               += vocdec.c voc.c
AVFORMAT_FILES-$(CONFIG_VOC_MUXER)                 += vocenc.c voc.c
AVFORMAT_FILES-$(CONFIG_VQF_DEMUXER)               += vqf.c
AVFORMAT_FILES-$(CONFIG_W64_DEMUXER)               += wav.c riff.c raw.c
AVFORMAT_FILES-$(CONFIG_WAV_DEMUXER)               += wav.c riff.c raw.c
AVFORMAT_FILES-$(CONFIG_WAV_MUXER)                 += wav.c riff.c
AVFORMAT_FILES-$(CONFIG_WC3_DEMUXER)               += wc3movie.c
AVFORMAT_FILES-$(CONFIG_WEBM_MUXER)                += matroskaenc.c matroska.c \
	riff.c isom.c avc.c \
	flacenc_header.c
AVFORMAT_FILES-$(CONFIG_WSAUD_DEMUXER)             += westwood.c
AVFORMAT_FILES-$(CONFIG_WSVQA_DEMUXER)             += westwood.c
AVFORMAT_FILES-$(CONFIG_WV_DEMUXER)                += wv.c apetag.c id3v1.c
AVFORMAT_FILES-$(CONFIG_XA_DEMUXER)                += xa.c
AVFORMAT_FILES-$(CONFIG_YOP_DEMUXER)               += yop.c
AVFORMAT_FILES-$(CONFIG_YUV4MPEGPIPE_MUXER)        += yuv4mpeg.c
AVFORMAT_FILES-$(CONFIG_YUV4MPEGPIPE_DEMUXER)      += yuv4mpeg.c

AVFORMAT_FILES-$(CONFIG_LIBNUT_DEMUXER)            += libnut.c riff.c
AVFORMAT_FILES-$(CONFIG_LIBNUT_MUXER)              += libnut.c riff.c

AVFORMAT_FILES-yes += avio.c aviobuf.c

AVFORMAT_FILES-$(CONFIG_FILE_PROTOCOL)             += file.c
AVFORMAT_FILES-$(CONFIG_GOPHER_PROTOCOL)           += gopher.c
AVFORMAT_FILES-$(CONFIG_HTTP_PROTOCOL)             += http.c httpauth.c
AVFORMAT_FILES-$(CONFIG_MMST_PROTOCOL)             += mmst.c asf.c
AVFORMAT_FILES-$(CONFIG_PIPE_PROTOCOL)             += file.c

RTMP-AVFORMAT_FILES-$(CONFIG_LIBRTMP)               = librtmp.c
RTMP-AVFORMAT_FILES-$(!CONFIG_LIBRTMP)              = rtmpproto.c rtmppkt.c
AVFORMAT_FILES-$(CONFIG_RTMP_PROTOCOL)             += $(RTMP-AVFORMAT_FILES-yes)

AVFORMAT_FILES-$(CONFIG_RTP_PROTOCOL)              += rtpproto.c
AVFORMAT_FILES-$(CONFIG_TCP_PROTOCOL)              += tcp.c
AVFORMAT_FILES-$(CONFIG_UDP_PROTOCOL)              += udp.c
AVFORMAT_FILES-$(CONFIG_CONCAT_PROTOCOL)           += concat.c

AVFORMAT_FILES-$(CONFIG_JACK_INDEV)                += timefilter.c

include $(CLEAR_VARS)
FFCFLAGS += -fno-PIC  -include $(LOCAL_PATH)/../config.h \
			-DHAVE_AV_CONFIG_H
LOCAL_MODULE = libavformat
LOCAL_CFLAGS = $(FFCFLAGS)
LOCAL_SRC_FILES = $(AVFORMAT_FILES-yes)
LOCAL_C_INCLUDES = $(LOCAL_PATH)/..
LOCAL_STATIC_LIBRARIES = libavutil 
include $(BUILD_STATIC_LIBRARY)


