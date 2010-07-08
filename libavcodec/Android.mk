LOCAL_PATH := $(call my-dir)
include  $(LOCAL_PATH)/../preconfig_x86_mmx_sse.mak

AVCODEC_FILES-yes = allcodecs.c                                                      \
       audioconvert.c                                                   \
       avpacket.c                                                       \
       bitstream.c                                                      \
       bitstream_filter.c                                               \
       dsputil.c                                                        \
       faanidct.c                                                       \
       imgconvert.c                                                     \
       jrevdct.c                                                        \
       opt.c                                                            \
       options.c                                                        \
       parser.c                                                         \
       raw.c                                                            \
       resample.c                                                       \
       resample2.c                                                      \
       simple_idct.c                                                    \
       utils.c                                                          \

# parts needed for many different codecs
AVCODEC_FILES-$(CONFIG_AANDCT)                  += aandcttab.c
AVCODEC_FILES-$(CONFIG_ENCODERS)                += faandct.c jfdctfst.c jfdctint.c
AVCODEC_FILES-$(CONFIG_DCT)                     += dct.c
AVCODEC_FILES-$(CONFIG_DWT)                     += dwt.c
AVCODEC_FILES-$(CONFIG_DXVA2)                   += dxva2.c
FFT-AVCODEC_FILES-$(CONFIG_HARDCODED_TABLES)    += cos_tables.c
AVCODEC_FILES-$(CONFIG_FFT)                     += avfft.c fft.c $(FFT-AVCODEC_FILES-yes)
AVCODEC_FILES-$(CONFIG_GOLOMB)                  += golomb.c
AVCODEC_FILES-$(CONFIG_H264DSP)                 += h264dsp.c h264idct.c h264pred.c
AVCODEC_FILES-$(CONFIG_LPC)                     += lpc.c
AVCODEC_FILES-$(CONFIG_LSP)                     += lsp.c
AVCODEC_FILES-$(CONFIG_MDCT)                    += mdct.c
RDFT-AVCODEC_FILES-$(CONFIG_HARDCODED_TABLES)   += sin_tables.c
AVCODEC_FILES-$(CONFIG_RDFT)                    += rdft.c $(RDFT-AVCODEC_FILES-yes)
AVCODEC_FILES-$(CONFIG_VAAPI)                   += vaapi.c
AVCODEC_FILES-$(CONFIG_VDPAU)                   += vdpau.c

# decoders/encoders/hardware accelerators
AVCODEC_FILES-$(CONFIG_AAC_DECODER)             += aacdec.c aactab.c aacsbr.c aacps.c
AVCODEC_FILES-$(CONFIG_AAC_ENCODER)             += aacenc.c aaccoder.c    \
                                          aacpsy.c aactab.c      \
                                          psymodel.c iirfilter.c \
                                          mpeg4audio.c
AVCODEC_FILES-$(CONFIG_AASC_DECODER)            += aasc.c msrledec.c
AVCODEC_FILES-$(CONFIG_AC3_DECODER)             += ac3dec.c ac3dec_data.c ac3.c
AVCODEC_FILES-$(CONFIG_AC3_ENCODER)             += ac3enc.c ac3tab.c ac3.c
AVCODEC_FILES-$(CONFIG_ALAC_DECODER)            += alac.c
AVCODEC_FILES-$(CONFIG_ALAC_ENCODER)            += alacenc.c
AVCODEC_FILES-$(CONFIG_ALS_DECODER)             += alsdec.c bgmc.c mpeg4audio.c
AVCODEC_FILES-$(CONFIG_AMRNB_DECODER)           += amrnbdec.c celp_filters.c   \
                                          celp_math.c acelp_filters.c \
                                          acelp_vectors.c             \
                                          acelp_pitch_delay.c
AVCODEC_FILES-$(CONFIG_AMV_DECODER)             += sp5xdec.c mjpegdec.c mjpeg.c
AVCODEC_FILES-$(CONFIG_ANM_DECODER)             += anm.c
AVCODEC_FILES-$(CONFIG_APE_DECODER)             += apedec.c
AVCODEC_FILES-$(CONFIG_ASV1_DECODER)            += asv1.c mpeg12data.c
AVCODEC_FILES-$(CONFIG_ASV1_ENCODER)            += asv1.c mpeg12data.c
AVCODEC_FILES-$(CONFIG_ASV2_DECODER)            += asv1.c mpeg12data.c
AVCODEC_FILES-$(CONFIG_ASV2_ENCODER)            += asv1.c mpeg12data.c
AVCODEC_FILES-$(CONFIG_ATRAC1_DECODER)          += atrac1.c atrac.c
AVCODEC_FILES-$(CONFIG_ATRAC3_DECODER)          += atrac3.c atrac.c
AVCODEC_FILES-$(CONFIG_AURA_DECODER)            += cyuv.c
AVCODEC_FILES-$(CONFIG_AURA2_DECODER)           += aura.c
AVCODEC_FILES-$(CONFIG_AVS_DECODER)             += avs.c
AVCODEC_FILES-$(CONFIG_BETHSOFTVID_DECODER)     += bethsoftvideo.c
AVCODEC_FILES-$(CONFIG_BFI_DECODER)             += bfi.c
AVCODEC_FILES-$(CONFIG_BINK_DECODER)            += bink.c binkidct.c
AVCODEC_FILES-$(CONFIG_BINKAUDIO_DCT_DECODER)   += binkaudio.c wma.c
AVCODEC_FILES-$(CONFIG_BINKAUDIO_RDFT_DECODER)  += binkaudio.c wma.c
AVCODEC_FILES-$(CONFIG_BMP_DECODER)             += bmp.c msrledec.c
AVCODEC_FILES-$(CONFIG_BMP_ENCODER)             += bmpenc.c
AVCODEC_FILES-$(CONFIG_C93_DECODER)             += c93.c
AVCODEC_FILES-$(CONFIG_CAVS_DECODER)            += cavs.c cavsdec.c cavsdsp.c \
                                          mpeg12data.c mpegvideo.c
AVCODEC_FILES-$(CONFIG_CDGRAPHICS_DECODER)      += cdgraphics.c
AVCODEC_FILES-$(CONFIG_CINEPAK_DECODER)         += cinepak.c
AVCODEC_FILES-$(CONFIG_CLJR_DECODER)            += cljr.c
AVCODEC_FILES-$(CONFIG_CLJR_ENCODER)            += cljr.c
AVCODEC_FILES-$(CONFIG_COOK_DECODER)            += cook.c
AVCODEC_FILES-$(CONFIG_CSCD_DECODER)            += cscd.c
AVCODEC_FILES-$(CONFIG_CYUV_DECODER)            += cyuv.c
AVCODEC_FILES-$(CONFIG_DCA_DECODER)             += dca.c synth_filter.c dcadsp.c
AVCODEC_FILES-$(CONFIG_DNXHD_DECODER)           += dnxhddec.c dnxhddata.c
AVCODEC_FILES-$(CONFIG_DNXHD_ENCODER)           += dnxhdenc.c dnxhddata.c       \
                                          mpegvideo_enc.c motion_est.c \
                                          ratecontrol.c mpeg12data.c   \
                                          mpegvideo.c
AVCODEC_FILES-$(CONFIG_DPX_DECODER)             += dpx.c
AVCODEC_FILES-$(CONFIG_DSICINAUDIO_DECODER)     += dsicinav.c
AVCODEC_FILES-$(CONFIG_DSICINVIDEO_DECODER)     += dsicinav.c
AVCODEC_FILES-$(CONFIG_DVBSUB_DECODER)          += dvbsubdec.c
AVCODEC_FILES-$(CONFIG_DVBSUB_ENCODER)          += dvbsub.c
AVCODEC_FILES-$(CONFIG_DVDSUB_DECODER)          += dvdsubdec.c
AVCODEC_FILES-$(CONFIG_DVDSUB_ENCODER)          += dvdsubenc.c
AVCODEC_FILES-$(CONFIG_DVVIDEO_DECODER)         += dv.c dvdata.c
AVCODEC_FILES-$(CONFIG_DVVIDEO_ENCODER)         += dv.c dvdata.c
AVCODEC_FILES-$(CONFIG_DXA_DECODER)             += dxa.c
AVCODEC_FILES-$(CONFIG_EAC3_DECODER)            += eac3dec.c eac3dec_data.c
AVCODEC_FILES-$(CONFIG_EACMV_DECODER)           += eacmv.c
AVCODEC_FILES-$(CONFIG_EAMAD_DECODER)           += eamad.c eaidct.c mpeg12.c \
                                          mpeg12data.c mpegvideo.c  \
                                          error_resilience.c
AVCODEC_FILES-$(CONFIG_EATGQ_DECODER)           += eatgq.c eaidct.c
AVCODEC_FILES-$(CONFIG_EATGV_DECODER)           += eatgv.c
AVCODEC_FILES-$(CONFIG_EATQI_DECODER)           += eatqi.c eaidct.c mpeg12.c \
                                          mpeg12data.c mpegvideo.c  \
                                          error_resilience.c
AVCODEC_FILES-$(CONFIG_EIGHTBPS_DECODER)        += 8bps.c
AVCODEC_FILES-$(CONFIG_EIGHTSVX_EXP_DECODER)    += 8svx.c
AVCODEC_FILES-$(CONFIG_EIGHTSVX_FIB_DECODER)    += 8svx.c
AVCODEC_FILES-$(CONFIG_ESCAPE124_DECODER)       += escape124.c
AVCODEC_FILES-$(CONFIG_FFV1_DECODER)            += ffv1.c rangecoder.c
AVCODEC_FILES-$(CONFIG_FFV1_ENCODER)            += ffv1.c rangecoder.c
AVCODEC_FILES-$(CONFIG_FFVHUFF_DECODER)         += huffyuv.c
AVCODEC_FILES-$(CONFIG_FFVHUFF_ENCODER)         += huffyuv.c
AVCODEC_FILES-$(CONFIG_FLAC_DECODER)            += flacdec.c flacdata.c flac.c
AVCODEC_FILES-$(CONFIG_FLAC_ENCODER)            += flacenc.c flacdata.c flac.c
AVCODEC_FILES-$(CONFIG_FLASHSV_DECODER)         += flashsv.c
AVCODEC_FILES-$(CONFIG_FLASHSV_ENCODER)         += flashsvenc.c
AVCODEC_FILES-$(CONFIG_FLIC_DECODER)            += flicvideo.c
AVCODEC_FILES-$(CONFIG_FOURXM_DECODER)          += 4xm.c
AVCODEC_FILES-$(CONFIG_FRAPS_DECODER)           += fraps.c huffman.c
AVCODEC_FILES-$(CONFIG_FRWU_DECODER)            += frwu.c
AVCODEC_FILES-$(CONFIG_GIF_DECODER)             += gifdec.c lzw.c
AVCODEC_FILES-$(CONFIG_GIF_ENCODER)             += gif.c lzwenc.c
AVCODEC_FILES-$(CONFIG_H261_DECODER)            += h261dec.c h261.c \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_H261_ENCODER)            += h261enc.c h261.c             \
                                          mpegvideo_enc.c motion_est.c \
                                          ratecontrol.c mpeg12data.c   \
                                          mpegvideo.c
AVCODEC_FILES-$(CONFIG_H263_DECODER)            += h263dec.c h263.c ituh263dec.c        \
                                          mpeg4video.c mpeg4videodec.c flvdec.c\
                                          intelh263dec.c mpegvideo.c           \
                                          error_resilience.c
AVCODEC_FILES-$(CONFIG_H263_VAAPI_HWACCEL)      += vaapi_mpeg4.c
AVCODEC_FILES-$(CONFIG_H263_ENCODER)            += mpegvideo_enc.c mpeg4video.c      \
                                          mpeg4videoenc.c motion_est.c      \
                                          ratecontrol.c h263.c ituh263enc.c \
                                          flvenc.c mpeg12data.c             \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_H264_DECODER)            += h264.c                               \
                                          h264_loopfilter.c h264_direct.c      \
                                          cabac.c h264_sei.c h264_ps.c         \
                                          h264_refs.c h264_cavlc.c h264_cabac.c\
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_H264_DXVA2_HWACCEL)      += dxva2_h264.c
AVCODEC_FILES-$(CONFIG_H264_ENCODER)            += h264enc.c h264dspenc.c
AVCODEC_FILES-$(CONFIG_H264_VAAPI_HWACCEL)      += vaapi_h264.c
AVCODEC_FILES-$(CONFIG_HUFFYUV_DECODER)         += huffyuv.c
AVCODEC_FILES-$(CONFIG_HUFFYUV_ENCODER)         += huffyuv.c
AVCODEC_FILES-$(CONFIG_IDCIN_DECODER)           += idcinvideo.c
AVCODEC_FILES-$(CONFIG_IFF_BYTERUN1_DECODER)    += iff.c
AVCODEC_FILES-$(CONFIG_IFF_ILBM_DECODER)        += iff.c
AVCODEC_FILES-$(CONFIG_IMC_DECODER)             += imc.c
AVCODEC_FILES-$(CONFIG_INDEO2_DECODER)          += indeo2.c
AVCODEC_FILES-$(CONFIG_INDEO3_DECODER)          += indeo3.c
AVCODEC_FILES-$(CONFIG_INDEO5_DECODER)          += indeo5.c ivi_common.c ivi_dsp.c
AVCODEC_FILES-$(CONFIG_INTERPLAY_DPCM_DECODER)  += dpcm.c
AVCODEC_FILES-$(CONFIG_INTERPLAY_VIDEO_DECODER) += interplayvideo.c
AVCODEC_FILES-$(CONFIG_JPEGLS_DECODER)          += jpeglsdec.c jpegls.c \
                                          mjpegdec.c mjpeg.c
AVCODEC_FILES-$(CONFIG_JPEGLS_ENCODER)          += jpeglsenc.c jpegls.c
AVCODEC_FILES-$(CONFIG_KGV1_DECODER)            += kgv1dec.c
AVCODEC_FILES-$(CONFIG_KMVC_DECODER)            += kmvc.c
AVCODEC_FILES-$(CONFIG_LJPEG_ENCODER)           += ljpegenc.c mjpegenc.c mjpeg.c \
                                          mpegvideo_enc.c motion_est.c  \
                                          ratecontrol.c mpeg12data.c    \
                                          mpegvideo.c
AVCODEC_FILES-$(CONFIG_LOCO_DECODER)            += loco.c
AVCODEC_FILES-$(CONFIG_MACE3_DECODER)           += mace.c
AVCODEC_FILES-$(CONFIG_MACE6_DECODER)           += mace.c
AVCODEC_FILES-$(CONFIG_MDEC_DECODER)            += mdec.c mpeg12.c mpeg12data.c \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_MIMIC_DECODER)           += mimic.c
AVCODEC_FILES-$(CONFIG_MJPEG_DECODER)           += mjpegdec.c mjpeg.c
AVCODEC_FILES-$(CONFIG_MJPEG_ENCODER)           += mjpegenc.c mjpeg.c           \
                                          mpegvideo_enc.c motion_est.c \
                                          ratecontrol.c mpeg12data.c   \
                                          mpegvideo.c
AVCODEC_FILES-$(CONFIG_MJPEGB_DECODER)          += mjpegbdec.c mjpegdec.c mjpeg.c
AVCODEC_FILES-$(CONFIG_MLP_DECODER)             += mlpdec.c mlpdsp.c
AVCODEC_FILES-$(CONFIG_MMVIDEO_DECODER)         += mmvideo.c
AVCODEC_FILES-$(CONFIG_MOTIONPIXELS_DECODER)    += motionpixels.c
AVCODEC_FILES-$(CONFIG_MP1_DECODER)             += mpegaudiodec.c mpegaudiodecheader.c \
                                          mpegaudio.c mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MP1FLOAT_DECODER)        += mpegaudiodec_float.c mpegaudiodecheader.c \
                                          mpegaudio.c mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MP2_DECODER)             += mpegaudiodec.c mpegaudiodecheader.c \
                                          mpegaudio.c mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MP2_ENCODER)             += mpegaudioenc.c mpegaudio.c \
                                          mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MP2FLOAT_DECODER)        += mpegaudiodec_float.c mpegaudiodecheader.c \
                                          mpegaudio.c mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MP3ADU_DECODER)          += mpegaudiodec.c mpegaudiodecheader.c \
                                          mpegaudio.c mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MP3ADUFLOAT_DECODER)     += mpegaudiodec_float.c mpegaudiodecheader.c \
                                          mpegaudio.c mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MP3ON4_DECODER)          += mpegaudiodec.c mpegaudiodecheader.c \
                                          mpegaudio.c mpegaudiodata.c         \
                                          mpeg4audio.c
AVCODEC_FILES-$(CONFIG_MP3ON4FLOAT_DECODER)     += mpegaudiodec_float.c mpegaudiodecheader.c \
                                          mpegaudio.c mpegaudiodata.c         \
                                          mpeg4audio.c
AVCODEC_FILES-$(CONFIG_MP3_DECODER)             += mpegaudiodec.c mpegaudiodecheader.c \
                                          mpegaudio.c mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MP3FLOAT_DECODER)        += mpegaudiodec_float.c mpegaudiodecheader.c \
                                          mpegaudio.c mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MPC7_DECODER)            += mpc7.c mpc.c mpegaudiodec.c      \
                                          mpegaudiodecheader.c mpegaudio.c \
                                          mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MPC8_DECODER)            += mpc8.c mpc.c mpegaudiodec.c      \
                                          mpegaudiodecheader.c mpegaudio.c \
                                          mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MPEGVIDEO_DECODER)       += mpeg12.c mpeg12data.c \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_MPEG_XVMC_DECODER)       += mpegvideo_xvmc.c
AVCODEC_FILES-$(CONFIG_MPEG1VIDEO_DECODER)      += mpeg12.c mpeg12data.c \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_MPEG1VIDEO_ENCODER)      += mpeg12enc.c mpegvideo_enc.c \
                                          motion_est.c ratecontrol.c  \
                                          mpeg12.c mpeg12data.c       \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_MPEG2_DXVA2_HWACCEL)     += dxva2_mpeg2.c
AVCODEC_FILES-$(CONFIG_MPEG2_VAAPI_HWACCEL)     += vaapi_mpeg2.c
AVCODEC_FILES-$(CONFIG_MPEG2VIDEO_DECODER)      += mpeg12.c mpeg12data.c \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_MPEG2VIDEO_ENCODER)      += mpeg12enc.c mpegvideo_enc.c \
                                          motion_est.c ratecontrol.c  \
                                          mpeg12.c mpeg12data.c       \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_MPEG4_VAAPI_HWACCEL)     += vaapi_mpeg4.c
AVCODEC_FILES-$(CONFIG_MSMPEG4V1_DECODER)       += msmpeg4.c msmpeg4data.c
AVCODEC_FILES-$(CONFIG_MSMPEG4V1_ENCODER)       += msmpeg4.c msmpeg4data.c h263dec.c \
                                          h263.c ituh263dec.c mpeg4videodec.c
AVCODEC_FILES-$(CONFIG_MSMPEG4V2_DECODER)       += msmpeg4.c msmpeg4data.c h263dec.c \
                                          h263.c ituh263dec.c mpeg4videodec.c
AVCODEC_FILES-$(CONFIG_MSMPEG4V2_ENCODER)       += msmpeg4.c msmpeg4data.c h263dec.c \
                                          h263.c ituh263dec.c mpeg4videodec.c
AVCODEC_FILES-$(CONFIG_MSMPEG4V3_DECODER)       += msmpeg4.c msmpeg4data.c h263dec.c \
                                          h263.c ituh263dec.c mpeg4videodec.c
AVCODEC_FILES-$(CONFIG_MSMPEG4V3_ENCODER)       += msmpeg4.c msmpeg4data.c h263dec.c \
                                          h263.c ituh263dec.c mpeg4videodec.c
AVCODEC_FILES-$(CONFIG_MSRLE_DECODER)           += msrle.c msrledec.c
AVCODEC_FILES-$(CONFIG_MSVIDEO1_DECODER)        += msvideo1.c
AVCODEC_FILES-$(CONFIG_MSZH_DECODER)            += lcldec.c
AVCODEC_FILES-$(CONFIG_NELLYMOSER_DECODER)      += nellymoserdec.c nellymoser.c
AVCODEC_FILES-$(CONFIG_NELLYMOSER_ENCODER)      += nellymoserenc.c nellymoser.c
AVCODEC_FILES-$(CONFIG_NUV_DECODER)             += nuv.c rtjpeg.c
AVCODEC_FILES-$(CONFIG_PAM_DECODER)             += pnmdec.c pnm.c
AVCODEC_FILES-$(CONFIG_PAM_ENCODER)             += pamenc.c pnm.c
AVCODEC_FILES-$(CONFIG_PBM_DECODER)             += pnmdec.c pnm.c
AVCODEC_FILES-$(CONFIG_PBM_ENCODER)             += pnmenc.c pnm.c
AVCODEC_FILES-$(CONFIG_PCX_DECODER)             += pcx.c
AVCODEC_FILES-$(CONFIG_PCX_ENCODER)             += pcxenc.c
AVCODEC_FILES-$(CONFIG_PGM_DECODER)             += pnmdec.c pnm.c
AVCODEC_FILES-$(CONFIG_PGM_ENCODER)             += pnmenc.c pnm.c
AVCODEC_FILES-$(CONFIG_PGMYUV_DECODER)          += pnmdec.c pnm.c
AVCODEC_FILES-$(CONFIG_PGMYUV_ENCODER)          += pnmenc.c pnm.c
AVCODEC_FILES-$(CONFIG_PGSSUB_DECODER)          += pgssubdec.c
AVCODEC_FILES-$(CONFIG_PICTOR_DECODER)          += pictordec.c cga_data.c
AVCODEC_FILES-$(CONFIG_PNG_DECODER)             += png.c pngdec.c
AVCODEC_FILES-$(CONFIG_PNG_ENCODER)             += png.c pngenc.c
AVCODEC_FILES-$(CONFIG_PPM_DECODER)             += pnmdec.c pnm.c
AVCODEC_FILES-$(CONFIG_PPM_ENCODER)             += pnmenc.c pnm.c
AVCODEC_FILES-$(CONFIG_PTX_DECODER)             += ptx.c
AVCODEC_FILES-$(CONFIG_QCELP_DECODER)           += qcelpdec.c celp_math.c         \
                                          celp_filters.c acelp_vectors.c \
                                          acelp_filters.c
AVCODEC_FILES-$(CONFIG_QDM2_DECODER)            += qdm2.c mpegaudiodec.c            \
                                          mpegaudiodecheader.c mpegaudio.c \
                                          mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_QDRAW_DECODER)           += qdrw.c
AVCODEC_FILES-$(CONFIG_QPEG_DECODER)            += qpeg.c
AVCODEC_FILES-$(CONFIG_QTRLE_DECODER)           += qtrle.c
AVCODEC_FILES-$(CONFIG_QTRLE_ENCODER)           += qtrleenc.c
AVCODEC_FILES-$(CONFIG_R210_DECODER)            += r210dec.c
AVCODEC_FILES-$(CONFIG_RA_144_DECODER)          += ra144dec.c ra144.c celp_filters.c
AVCODEC_FILES-$(CONFIG_RA_144_ENCODER)          += ra144enc.c ra144.c celp_filters.c
AVCODEC_FILES-$(CONFIG_RA_288_DECODER)          += ra288.c celp_math.c celp_filters.c
AVCODEC_FILES-$(CONFIG_RAWVIDEO_DECODER)        += rawdec.c
AVCODEC_FILES-$(CONFIG_RAWVIDEO_ENCODER)        += rawenc.c
AVCODEC_FILES-$(CONFIG_RL2_DECODER)             += rl2.c
AVCODEC_FILES-$(CONFIG_ROQ_DECODER)             += roqvideodec.c roqvideo.c
AVCODEC_FILES-$(CONFIG_ROQ_ENCODER)             += roqvideoenc.c roqvideo.c elbg.c
AVCODEC_FILES-$(CONFIG_ROQ_DPCM_DECODER)        += dpcm.c
AVCODEC_FILES-$(CONFIG_ROQ_DPCM_ENCODER)        += roqaudioenc.c
AVCODEC_FILES-$(CONFIG_RPZA_DECODER)            += rpza.c
AVCODEC_FILES-$(CONFIG_RV10_DECODER)            += rv10.c
AVCODEC_FILES-$(CONFIG_RV10_ENCODER)            += rv10enc.c
AVCODEC_FILES-$(CONFIG_RV20_DECODER)            += rv10.c
AVCODEC_FILES-$(CONFIG_RV20_ENCODER)            += rv20enc.c
AVCODEC_FILES-$(CONFIG_RV30_DECODER)            += rv30.c rv34.c rv30dsp.c        \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_RV40_DECODER)            += rv40.c rv34.c rv40dsp.c        \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_SGI_DECODER)             += sgidec.c
AVCODEC_FILES-$(CONFIG_SGI_ENCODER)             += sgienc.c rle.c
AVCODEC_FILES-$(CONFIG_SHORTEN_DECODER)         += shorten.c
AVCODEC_FILES-$(CONFIG_SIPR_DECODER)            += sipr.c acelp_pitch_delay.c \
                                          celp_math.c acelp_vectors.c \
                                          acelp_filters.c celp_filters.c \
                                          sipr16k.c
AVCODEC_FILES-$(CONFIG_SMACKAUD_DECODER)        += smacker.c
AVCODEC_FILES-$(CONFIG_SMACKER_DECODER)         += smacker.c
AVCODEC_FILES-$(CONFIG_SMC_DECODER)             += smc.c
AVCODEC_FILES-$(CONFIG_SNOW_DECODER)            += snow.c rangecoder.c
AVCODEC_FILES-$(CONFIG_SNOW_ENCODER)            += snow.c rangecoder.c motion_est.c \
                                          ratecontrol.c h263.c             \
                                          mpegvideo.c error_resilience.c   \
                                          ituh263enc.c mpegvideo_enc.c     \
                                          mpeg12data.c
AVCODEC_FILES-$(CONFIG_SOL_DPCM_DECODER)        += dpcm.c
AVCODEC_FILES-$(CONFIG_SONIC_DECODER)           += sonic.c
AVCODEC_FILES-$(CONFIG_SONIC_ENCODER)           += sonic.c
AVCODEC_FILES-$(CONFIG_SONIC_LS_ENCODER)        += sonic.c
AVCODEC_FILES-$(CONFIG_SP5X_DECODER)            += sp5xdec.c mjpegdec.c mjpeg.c
AVCODEC_FILES-$(CONFIG_SUNRAST_DECODER)         += sunrast.c
AVCODEC_FILES-$(CONFIG_SVQ1_DECODER)            += svq1dec.c svq1.c h263.c \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_SVQ1_ENCODER)            += svq1enc.c svq1.c    \
                                          motion_est.c h263.c \
                                          mpegvideo.c error_resilience.c \
                                          ituh263enc.c mpegvideo_enc.c   \
                                          ratecontrol.c mpeg12data.c
AVCODEC_FILES-$(CONFIG_SVQ3_DECODER)            += h264.c svq3.c                       \
                                          h264_loopfilter.c h264_direct.c     \
                                          h264_sei.c h264_ps.c h264_refs.c    \
                                          h264_cavlc.c h264_cabac.c cabac.c   \
                                          mpegvideo.c error_resilience.c      \
                                          svq1dec.c svq1.c h263.c
AVCODEC_FILES-$(CONFIG_TARGA_DECODER)           += targa.c
AVCODEC_FILES-$(CONFIG_TARGA_ENCODER)           += targaenc.c rle.c
AVCODEC_FILES-$(CONFIG_THEORA_DECODER)          += xiph.c
AVCODEC_FILES-$(CONFIG_THP_DECODER)             += mjpegdec.c mjpeg.c
AVCODEC_FILES-$(CONFIG_TIERTEXSEQVIDEO_DECODER) += tiertexseqv.c
AVCODEC_FILES-$(CONFIG_TIFF_DECODER)            += tiff.c lzw.c faxcompr.c
AVCODEC_FILES-$(CONFIG_TIFF_ENCODER)            += tiffenc.c rle.c lzwenc.c
AVCODEC_FILES-$(CONFIG_TMV_DECODER)             += tmv.c cga_data.c
AVCODEC_FILES-$(CONFIG_TRUEMOTION1_DECODER)     += truemotion1.c
AVCODEC_FILES-$(CONFIG_TRUEMOTION2_DECODER)     += truemotion2.c
AVCODEC_FILES-$(CONFIG_TRUESPEECH_DECODER)      += truespeech.c
AVCODEC_FILES-$(CONFIG_TSCC_DECODER)            += tscc.c msrledec.c
AVCODEC_FILES-$(CONFIG_TTA_DECODER)             += tta.c
AVCODEC_FILES-$(CONFIG_TWINVQ_DECODER)          += twinvq.c celp_math.c
AVCODEC_FILES-$(CONFIG_TXD_DECODER)             += txd.c s3tc.c
AVCODEC_FILES-$(CONFIG_ULTI_DECODER)            += ulti.c
AVCODEC_FILES-$(CONFIG_V210_DECODER)            += v210dec.c
AVCODEC_FILES-$(CONFIG_V210_ENCODER)            += v210enc.c
AVCODEC_FILES-$(CONFIG_V210X_DECODER)           += v210x.c
AVCODEC_FILES-$(CONFIG_VB_DECODER)              += vb.c
AVCODEC_FILES-$(CONFIG_VC1_DECODER)             += vc1dec.c vc1.c vc1data.c vc1dsp.c \
                                          msmpeg4.c msmpeg4data.c           \
                                          intrax8.c intrax8dsp.c
AVCODEC_FILES-$(CONFIG_VC1_DXVA2_HWACCEL)       += dxva2_vc1.c
AVCODEC_FILES-$(CONFIG_VC1_VAAPI_HWACCEL)       += vaapi_vc1.c
AVCODEC_FILES-$(CONFIG_VCR1_DECODER)            += vcr1.c
AVCODEC_FILES-$(CONFIG_VCR1_ENCODER)            += vcr1.c
AVCODEC_FILES-$(CONFIG_VMDAUDIO_DECODER)        += vmdav.c
AVCODEC_FILES-$(CONFIG_VMDVIDEO_DECODER)        += vmdav.c
AVCODEC_FILES-$(CONFIG_VMNC_DECODER)            += vmnc.c
AVCODEC_FILES-$(CONFIG_VORBIS_DECODER)          += vorbis_dec.c vorbis.c \
                                          vorbis_data.c xiph.c
AVCODEC_FILES-$(CONFIG_VORBIS_ENCODER)          += vorbis_enc.c vorbis.c \
                                          vorbis_data.c
AVCODEC_FILES-$(CONFIG_VP3_DECODER)             += vp3.c vp3dsp.c
AVCODEC_FILES-$(CONFIG_VP5_DECODER)             += vp5.c vp56.c vp56data.c vp56dsp.c \
                                          vp3dsp.c cabac.c
AVCODEC_FILES-$(CONFIG_VP6_DECODER)             += vp6.c vp56.c vp56data.c vp56dsp.c \
                                          vp3dsp.c vp6dsp.c huffman.c cabac.c
AVCODEC_FILES-$(CONFIG_VP8_DECODER)             += vp8.c vp8dsp.c vp56.c vp56data.c \
                                          h264pred.c cabac.c
AVCODEC_FILES-$(CONFIG_VQA_DECODER)             += vqavideo.c
AVCODEC_FILES-$(CONFIG_WAVPACK_DECODER)         += wavpack.c
AVCODEC_FILES-$(CONFIG_WMAPRO_DECODER)          += wmaprodec.c wma.c
AVCODEC_FILES-$(CONFIG_WMAV1_DECODER)           += wmadec.c wma.c aactab.c
AVCODEC_FILES-$(CONFIG_WMAV1_ENCODER)           += wmaenc.c wma.c aactab.c
AVCODEC_FILES-$(CONFIG_WMAV2_DECODER)           += wmadec.c wma.c aactab.c
AVCODEC_FILES-$(CONFIG_WMAV2_ENCODER)           += wmaenc.c wma.c aactab.c
AVCODEC_FILES-$(CONFIG_WMAVOICE_DECODER)        += wmavoice.c \
                                          celp_math.c celp_filters.c \
                                          acelp_vectors.c acelp_filters.c
AVCODEC_FILES-$(CONFIG_WMV1_DECODER)            += msmpeg4.c msmpeg4data.c
AVCODEC_FILES-$(CONFIG_WMV2_DECODER)            += wmv2dec.c wmv2.c        \
                                          msmpeg4.c msmpeg4data.c \
                                          intrax8.c intrax8dsp.c
AVCODEC_FILES-$(CONFIG_WMV2_ENCODER)            += wmv2enc.c wmv2.c \
                                          msmpeg4.c msmpeg4data.c \
                                          mpeg4videodec.c ituh263dec.c h263dec.c
AVCODEC_FILES-$(CONFIG_WNV1_DECODER)            += wnv1.c
AVCODEC_FILES-$(CONFIG_WS_SND1_DECODER)         += ws-snd1.c
AVCODEC_FILES-$(CONFIG_XAN_DPCM_DECODER)        += dpcm.c
AVCODEC_FILES-$(CONFIG_XAN_WC3_DECODER)         += xan.c
AVCODEC_FILES-$(CONFIG_XAN_WC4_DECODER)         += xan.c
AVCODEC_FILES-$(CONFIG_XL_DECODER)              += xl.c
AVCODEC_FILES-$(CONFIG_XSUB_DECODER)            += xsubdec.c
AVCODEC_FILES-$(CONFIG_XSUB_ENCODER)            += xsubenc.c
AVCODEC_FILES-$(CONFIG_YOP_DECODER)             += yop.c
AVCODEC_FILES-$(CONFIG_ZLIB_DECODER)            += lcldec.c
AVCODEC_FILES-$(CONFIG_ZLIB_ENCODER)            += lclenc.c
AVCODEC_FILES-$(CONFIG_ZMBV_DECODER)            += zmbv.c
AVCODEC_FILES-$(CONFIG_ZMBV_ENCODER)            += zmbvenc.c

# (AD)PCM decoders/encoders
AVCODEC_FILES-$(CONFIG_PCM_ALAW_DECODER)           += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_ALAW_ENCODER)           += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_BLURAY_DECODER)         += pcm-mpeg.c
AVCODEC_FILES-$(CONFIG_PCM_DVD_DECODER)            += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_DVD_ENCODER)            += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_F32BE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_F32BE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_F32LE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_F32LE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_F64BE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_F64BE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_F64LE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_F64LE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_MULAW_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_MULAW_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S8_DECODER)             += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S8_ENCODER)             += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S16BE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S16BE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S16LE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S16LE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S16LE_PLANAR_DECODER)   += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S24BE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S24BE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S24DAUD_DECODER)        += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S24DAUD_ENCODER)        += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S24LE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S24LE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S32BE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S32BE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S32LE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_S32LE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U8_DECODER)             += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U8_ENCODER)             += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U16BE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U16BE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U16LE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U16LE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U24BE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U24BE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U24LE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U24LE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U32BE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U32BE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U32LE_DECODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_U32LE_ENCODER)          += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_ZORK_DECODER)           += pcm.c
AVCODEC_FILES-$(CONFIG_PCM_ZORK_ENCODER)           += pcm.c

AVCODEC_FILES-$(CONFIG_ADPCM_4XM_DECODER)          += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_ADX_DECODER)          += adxdec.c
AVCODEC_FILES-$(CONFIG_ADPCM_ADX_ENCODER)          += adxenc.c
AVCODEC_FILES-$(CONFIG_ADPCM_CT_DECODER)           += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_EA_DECODER)           += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_EA_MAXIS_XA_DECODER)  += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_EA_R1_DECODER)        += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_EA_R2_DECODER)        += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_EA_R3_DECODER)        += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_EA_XAS_DECODER)       += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_G726_DECODER)         += g726.c
AVCODEC_FILES-$(CONFIG_ADPCM_G726_ENCODER)         += g726.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_AMV_DECODER)      += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_DK3_DECODER)      += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_DK4_DECODER)      += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_EA_EACS_DECODER)  += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_EA_SEAD_DECODER)  += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_ISS_DECODER)      += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_QT_DECODER)       += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_QT_ENCODER)       += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_SMJPEG_DECODER)   += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_WAV_DECODER)      += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_WAV_ENCODER)      += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_IMA_WS_DECODER)       += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_MS_DECODER)           += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_MS_ENCODER)           += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_SBPRO_2_DECODER)      += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_SBPRO_3_DECODER)      += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_SBPRO_4_DECODER)      += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_SWF_DECODER)          += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_SWF_ENCODER)          += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_THP_DECODER)          += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_XA_DECODER)           += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_YAMAHA_DECODER)       += adpcm.c
AVCODEC_FILES-$(CONFIG_ADPCM_YAMAHA_ENCODER)       += adpcm.c

# libavformat dependencies
AVCODEC_FILES-$(CONFIG_ADTS_MUXER)              += mpeg4audio.c
AVCODEC_FILES-$(CONFIG_CAF_DEMUXER)             += mpeg4audio.c mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_DV_DEMUXER)              += dvdata.c
AVCODEC_FILES-$(CONFIG_DV_MUXER)                += dvdata.c
AVCODEC_FILES-$(CONFIG_FLAC_DEMUXER)            += flacdec.c flacdata.c flac.c
AVCODEC_FILES-$(CONFIG_FLAC_MUXER)              += flacdec.c flacdata.c flac.c
AVCODEC_FILES-$(CONFIG_FLV_DEMUXER)             += mpeg4audio.c
AVCODEC_FILES-$(CONFIG_GXF_DEMUXER)             += mpeg12data.c
AVCODEC_FILES-$(CONFIG_IFF_DEMUXER)             += iff.c
AVCODEC_FILES-$(CONFIG_MATROSKA_AUDIO_MUXER)    += xiph.c mpeg4audio.c \
                                          flacdec.c flacdata.c flac.c
AVCODEC_FILES-$(CONFIG_MATROSKA_DEMUXER)        += mpeg4audio.c
AVCODEC_FILES-$(CONFIG_MATROSKA_MUXER)          += xiph.c mpeg4audio.c \
                                          flacdec.c flacdata.c flac.c
AVCODEC_FILES-$(CONFIG_MOV_DEMUXER)             += mpeg4audio.c mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MPEGTS_MUXER)            += mpegvideo.c mpeg4audio.c
AVCODEC_FILES-$(CONFIG_NUT_MUXER)               += mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_OGG_DEMUXER)             += flacdec.c flacdata.c flac.c \
                                          dirac.c mpeg12data.c
AVCODEC_FILES-$(CONFIG_OGG_MUXER)               += xiph.c flacdec.c flacdata.c flac.c
AVCODEC_FILES-$(CONFIG_RTP_MUXER)               += mpegvideo.c
AVCODEC_FILES-$(CONFIG_WEBM_MUXER)              += xiph.c mpeg4audio.c \
                                          flacdec.c flacdata.c flac.c

# external codec libraries
AVCODEC_FILES-$(CONFIG_LIBDIRAC_DECODER)           += libdiracdec.c
AVCODEC_FILES-$(CONFIG_LIBDIRAC_ENCODER)           += libdiracenc.c libdirac_libschro.c
AVCODEC_FILES-$(CONFIG_LIBFAAC_ENCODER)            += libfaac.c
AVCODEC_FILES-$(CONFIG_LIBGSM_DECODER)             += libgsm.c
AVCODEC_FILES-$(CONFIG_LIBGSM_ENCODER)             += libgsm.c
AVCODEC_FILES-$(CONFIG_LIBGSM_MS_DECODER)          += libgsm.c
AVCODEC_FILES-$(CONFIG_LIBGSM_MS_ENCODER)          += libgsm.c
AVCODEC_FILES-$(CONFIG_LIBMP3LAME_ENCODER)         += libmp3lame.c
AVCODEC_FILES-$(CONFIG_LIBOPENCORE_AMRNB_DECODER)  += libopencore-amr.c
AVCODEC_FILES-$(CONFIG_LIBOPENCORE_AMRNB_ENCODER)  += libopencore-amr.c
AVCODEC_FILES-$(CONFIG_LIBOPENCORE_AMRWB_DECODER)  += libopencore-amr.c
AVCODEC_FILES-$(CONFIG_LIBOPENJPEG_DECODER)        += libopenjpeg.c
AVCODEC_FILES-$(CONFIG_LIBSCHROEDINGER_DECODER)    += libschroedingerdec.c \
                                             libschroedinger.c    \
                                             libdirac_libschro.c
AVCODEC_FILES-$(CONFIG_LIBSCHROEDINGER_ENCODER)    += libschroedingerenc.c \
                                             libschroedinger.c    \
                                             libdirac_libschro.c
AVCODEC_FILES-$(CONFIG_LIBSPEEX_DECODER)           += libspeexdec.c
AVCODEC_FILES-$(CONFIG_LIBTHEORA_ENCODER)          += libtheoraenc.c
AVCODEC_FILES-$(CONFIG_LIBVORBIS_ENCODER)          += libvorbis.c vorbis_data.c
AVCODEC_FILES-$(CONFIG_LIBVPX_DECODER)             += libvpxdec.c
AVCODEC_FILES-$(CONFIG_LIBVPX_ENCODER)             += libvpxenc.c
AVCODEC_FILES-$(CONFIG_LIBX264_ENCODER)            += libx264.c
AVCODEC_FILES-$(CONFIG_LIBXVID_ENCODER)            += libxvidff.c libxvid_rc.c

# parsers
AVCODEC_FILES-$(CONFIG_AAC_PARSER)              += aac_parser.c aac_ac3_parser.c \
                                          mpeg4audio.c
AVCODEC_FILES-$(CONFIG_AC3_PARSER)              += ac3_parser.c ac3tab.c \
                                          aac_ac3_parser.c
AVCODEC_FILES-$(CONFIG_CAVSVIDEO_PARSER)        += cavs_parser.c
AVCODEC_FILES-$(CONFIG_DCA_PARSER)              += dca_parser.c
AVCODEC_FILES-$(CONFIG_DIRAC_PARSER)            += dirac_parser.c
AVCODEC_FILES-$(CONFIG_DNXHD_PARSER)            += dnxhd_parser.c
AVCODEC_FILES-$(CONFIG_DVBSUB_PARSER)           += dvbsub_parser.c
AVCODEC_FILES-$(CONFIG_DVDSUB_PARSER)           += dvdsub_parser.c
AVCODEC_FILES-$(CONFIG_H261_PARSER)             += h261_parser.c
AVCODEC_FILES-$(CONFIG_H263_PARSER)             += h263_parser.c
AVCODEC_FILES-$(CONFIG_H264_PARSER)             += h264_parser.c h264.c            \
                                          cabac.c                         \
                                          h264_refs.c h264_sei.c h264_direct.c \
                                          h264_loopfilter.c h264_cabac.c \
                                          h264_cavlc.c h264_ps.c \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_MJPEG_PARSER)            += mjpeg_parser.c
AVCODEC_FILES-$(CONFIG_MLP_PARSER)              += mlp_parser.c mlp.c
AVCODEC_FILES-$(CONFIG_MPEG4VIDEO_PARSER)       += mpeg4video_parser.c h263.c \
                                          mpegvideo.c error_resilience.c \
                                          mpeg4videodec.c mpeg4video.c \
                                          ituh263dec.c h263dec.c
AVCODEC_FILES-$(CONFIG_MPEGAUDIO_PARSER)        += mpegaudio_parser.c \
                                          mpegaudiodecheader.c mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_MPEGVIDEO_PARSER)        += mpegvideo_parser.c    \
                                          mpeg12.c mpeg12data.c \
                                          mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_PNM_PARSER)              += pnm_parser.c pnm.c
AVCODEC_FILES-$(CONFIG_VC1_PARSER)              += vc1_parser.c vc1.c vc1data.c \
                                          msmpeg4.c msmpeg4data.c mpeg4video.c \
                                          h263.c mpegvideo.c error_resilience.c
AVCODEC_FILES-$(CONFIG_VP3_PARSER)              += vp3_parser.c
AVCODEC_FILES-$(CONFIG_VP8_PARSER)              += vp8_parser.c

# bitstream filters
AVCODEC_FILES-$(CONFIG_AAC_ADTSTOASC_BSF)          += aac_adtstoasc_bsf.c
AVCODEC_FILES-$(CONFIG_CHOMP_BSF)                  += chomp_bsf.c
AVCODEC_FILES-$(CONFIG_DUMP_EXTRADATA_BSF)         += dump_extradata_bsf.c
AVCODEC_FILES-$(CONFIG_H264_MP4TOANNEXB_BSF)       += h264_mp4toannexb_bsf.c
AVCODEC_FILES-$(CONFIG_IMX_DUMP_HEADER_BSF)        += imx_dump_header_bsf.c
AVCODEC_FILES-$(CONFIG_MJPEGA_DUMP_HEADER_BSF)     += mjpega_dump_header_bsf.c
AVCODEC_FILES-$(CONFIG_MOV2TEXTSUB_BSF)            += movsub_bsf.c
AVCODEC_FILES-$(CONFIG_MP3_HEADER_COMPRESS_BSF)    += mp3_header_compress_bsf.c
AVCODEC_FILES-$(CONFIG_MP3_HEADER_DECOMPRESS_BSF)  += mp3_header_decompress_bsf.c \
                                             mpegaudiodata.c
AVCODEC_FILES-$(CONFIG_NOISE_BSF)                  += noise_bsf.c
AVCODEC_FILES-$(CONFIG_REMOVE_EXTRADATA_BSF)       += remove_extradata_bsf.c
AVCODEC_FILES-$(CONFIG_TEXT2MOVSUB_BSF)            += movsub_bsf.c

# thread libraries
AVCODEC_FILES-$(HAVE_PTHREADS)                  += pthread.c
AVCODEC_FILES-$(HAVE_W32THREADS)                += w32thread.c

AVCODEC_FILES-$(CONFIG_MLIB)                    += mlib/dsputil_mlib.c           \

AVCODEC_FILES-$(CONFIG_MLP_DECODER)             += x86/mlpdsp.c
AVCODEC_FILES-$(CONFIG_TRUEHD_DECODER)          += x86/mlpdsp.c

YASM-OBJS-FFT-$(HAVE_AMD3DNOW)         += x86/fft_3dn.c
YASM-OBJS-FFT-$(HAVE_AMD3DNOWEXT)      += x86/fft_3dn2.c
YASM-OBJS-FFT-$(HAVE_SSE)              += x86/fft_sse.c
AVCODEC_FILES-$(CONFIG_FFT)                += x86/fft_mmx.asm\
                                          $(YASM-OBJS-FFT-yes)
AVCODEC_FILES-$(CONFIG_GPL)                += x86/h264_deblock_sse2.asm       \
                                          x86/h264_idct_sse2.asm          \

AVCODEC_FILES-$(CONFIG_H264DSP)            += x86/h264_intrapred.asm          \
AVCODEC_FILES-$(CONFIG_VP8_DECODER)        += x86/vp8dsp.asm

MMX-OBJS-$(CONFIG_CAVS_DECODER)        += x86/cavsdsp_mmx.c
MMX-OBJS-$(CONFIG_MP1FLOAT_DECODER)    += x86/mpegaudiodec_mmx.c
MMX-OBJS-$(CONFIG_MP2FLOAT_DECODER)    += x86/mpegaudiodec_mmx.c
MMX-OBJS-$(CONFIG_MP3FLOAT_DECODER)    += x86/mpegaudiodec_mmx.c
MMX-OBJS-$(CONFIG_MP3ON4FLOAT_DECODER) += x86/mpegaudiodec_mmx.c
MMX-OBJS-$(CONFIG_MP3ADUFLOAT_DECODER) += x86/mpegaudiodec_mmx.c
MMX-OBJS-$(CONFIG_ENCODERS)            += x86/dsputilenc_mmx.c
MMX-OBJS-$(CONFIG_GPL)                 += x86/idct_mmx.c
MMX-OBJS-$(CONFIG_LPC)                 += x86/lpc_mmx.c
MMX-OBJS-$(CONFIG_DWT)                 += x86/snowdsp_mmx.c
MMX-OBJS-$(CONFIG_VC1_DECODER)         += x86/vc1dsp_mmx.c
MMX-OBJS-$(CONFIG_VP3_DECODER)         += x86/vp3dsp_mmx.c              \
                                          x86/vp3dsp_sse2.c
MMX-OBJS-$(CONFIG_VP5_DECODER)         += x86/vp3dsp_mmx.c              \
                                          x86/vp3dsp_sse2.c
MMX-OBJS-$(CONFIG_VP6_DECODER)         += x86/vp3dsp_mmx.c              \
                                          x86/vp3dsp_sse2.c             \
                                          x86/vp6dsp_mmx.c              \
                                          x86/vp6dsp_sse2.c
MMX-OBJS-$(CONFIG_VP8_DECODER)         += x86/vp8dsp-init.c
MMX-OBJS-$(HAVE_YASM)                  += x86/dsputil_yasm.asm            \
                                          $(YASM-OBJS-yes)

MMX-OBJS-$(CONFIG_FFT)                 += x86/fft.c

AVCODEC_FILES-$(HAVE_MMX)                       += x86/cpuid.c                   \
                                          x86/dnxhd_mmx.c               \
                                          x86/dsputil_mmx.c             \
                                          x86/fdct_mmx.c                \
                                          x86/idct_mmx_xvid.c           \
                                          x86/idct_sse2_xvid.c          \
                                          x86/motion_est_mmx.c          \
                                          x86/mpegvideo_mmx.c           \
                                          x86/simple_idct_mmx.c         \

AVCODEC_FILES-$(HAVE_MMX) += $(MMX-OBJS-yes)
AVCODEC_FILES := $(sort $(AVCODEC_FILES-yes))

FFCFLAGS += -include $(LOCAL_PATH)/../config.h \
			-DHAVE_AV_CONFIG_H

include $(CLEAR_VARS)
LOCAL_MODULE = libavcodec
LOCAL_CFLAGS = $(FFCFLAGS)
LOCAL_SRC_FILES = $(AVCODEC_FILES)
LOCAL_C_INCLUDES = $(LOCAL_PATH) $(LOCAL_PATH)/.. \
				   $(LOCAL_PATH)/x86 external/zlib
LOCAL_SHARED_LIBRARIES = libz
LOCAL_STATIC_LIBRARIES = libavutil 
include $(BUILD_STATIC_LIBRARY)
include $(CLEAR_VARS)
LOCAL_MODULE = libavcodec_snow
LOCAL_MODULE_TAGS := debug
LOCAL_CFLAGS = $(FFCFLAGS) -DTEST
LOCAL_SRC_FILES = snow.c
LOCAL_C_INCLUDES = $(LOCAL_PATH)/.. $(LOCAL_PATH)/x86
LOCAL_STATIC_LIBRARIES = libz
LOCAL_STATIC_LIBRARIES = libavcodec libavutil 
include $(BUILD_EXECUTABLE)
include $(CLEAR_VARS)
LOCAL_MODULE = libavcodec_cpuid
LOCAL_CFLAGS = $(FFCFLAGS)  -DTEST
LOCAL_MODULE_TAGS := debug
LOCAL_SRC_FILES = x86/cpuid.c
LOCAL_C_INCLUDES = $(LOCAL_PATH)/.. $(LOCAL_PATH)/x86
LOCAL_STATIC_LIBRARIES = libz
LOCAL_STATIC_LIBRARIES = libavcodec 
include $(BUILD_EXECUTABLE)
include $(CLEAR_VARS)
LOCAL_MODULE = libavcodec_motion
LOCAL_CFLAGS = $(FFCFLAGS)  -DTEST
LOCAL_SRC_FILES = motion-test.c
LOCAL_MODULE_TAGS := debug
LOCAL_C_INCLUDES = $(LOCAL_PATH)/..
LOCAL_STATIC_LIBRARIES = libz
LOCAL_STATIC_LIBRARIES = libavcodec libavutil  
include $(BUILD_EXECUTABLE)

