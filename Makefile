FFMPEG_VERSION = 4.1
SRC_FFMPEG = ffmpeg-$(FFMPEG_VERSION).tar.bz2
#mp4
LAME_VERSION = 3.99.5
FDKAAC_VERSION = 2.0.0
X264_VERSION = 20180925
SRC_LAME = lame-$(LAME_VERSION).tar.gz
SRC_FDKAAC = fdk-aac-$(FDKAAC_VERSION).tar.gz
SRC_X264 = x264-$(X264_VERSION).tar.gz
#webm
FREETYPE_VERSION = 2.9.1
FRIBIDI_VERSION = 1.0.5
LIBASS_VERSION = 0.14.0
LIBVPX_VERSION = 1.7.0
OPUS_VERSION = 1.3
SRC_FREETYPE = freetype-$(FREETYPE_VERSION).tar.gz
SRC_FRIBIDI =fribidi-$(FRIBIDI_VERSION).tar.gz
SRC_LIBASS = libass-$(LIBASS_VERSION).tar.gz
SRC_LIBVPX = libvpx-$(LIBVPX_VERSION).tar.gz
SRC_OPUS = opus-$(OPUS_VERSION).tar.gz

WORK_PATH := $(shell pwd)
FFMPEG_PKG_PATH = ../dist/lib/pkgconfig


all: alljs mp4js webmjs 

alljs: ffmpeg.js ffmpeg-worker.js
mp4js: ffmpeg-mp4.js ffmpeg-mp4-worker.js
webmjs: ffmpeg-webm.js ffmpeg-webm-worker.js

clean: 
	rm -rf build
	rm ffmpeg*.js ffmpeg*.wasm
cleanpc:
	rm -rf buildpc

#share lib deps 
LIBASS_DEPS = \
	build/dist/lib/libfribidi.so \
	build/dist/lib/libfreetype.so
WEBM_SHARED_DEPS = \
	$(LIBASS_DEPS) \
	build/dist/lib/libass.so \
	build/dist/lib/libopus.so \
	build/dist/lib/libvpx.so

MP4_SHARED_DEPS = \
	build/dist/lib/libmp3lame.so \
	build/dist/lib/libfdk-aac.so \
	build/dist/lib/libx264.so

SHARED_DEPS = \
	$(MP4_SHARED_DEPS) \
	$(WEBM_SHARED_DEPS) \

#ready action
SOURCE_REDAY = cp_source_code tar_source_code 
#SOURCE_REDAY = 
cp_source_code:
	mkdir build && \
	cp src/$(SRC_FFMPEG) build && \
	\
	cp src/$(SRC_LAME) build && \
	cp src/$(SRC_FDKAAC) build && \
	cp src/$(SRC_X264) build && \
	\
	cp src/$(SRC_FREETYPE) build && \
	cp src/$(SRC_FRIBIDI) build && \
	cp src/$(SRC_LIBASS) build && \
	cp src/$(SRC_LIBVPX) build && \
	cp src/$(SRC_OPUS) build

tar_source_code:
	cd build && \
	tar xvf $(SRC_FFMPEG) && mv ffmpeg-$(FFMPEG_VERSION) ffmpeg-mp4-$(FFMPEG_VERSION) && \
	tar xvf $(SRC_FFMPEG) && mv ffmpeg-$(FFMPEG_VERSION) ffmpeg-webm-$(FFMPEG_VERSION)&& \
	tar xvf $(SRC_FFMPEG) && rm $(SRC_FFMPEG) && \
	\
	tar xvf $(SRC_LAME) && rm $(SRC_LAME) && \
	tar xvf $(SRC_FDKAAC) && rm $(SRC_FDKAAC) && \
	tar xvf $(SRC_X264) && rm $(SRC_X264) && \
	\
	tar xvf $(SRC_FREETYPE) && rm $(SRC_FREETYPE) && \
	tar xvf $(SRC_FRIBIDI) && rm $(SRC_FRIBIDI) && \
	tar xvf $(SRC_LIBASS) && rm $(SRC_LIBASS) && \
	tar xvf $(SRC_LIBVPX) && rm $(SRC_LIBVPX) && \
	tar xvf $(SRC_OPUS) && rm $(SRC_OPUS) 


#mp4 share library compile
build/dist/lib/libmp3lame.so:
	cd build/lame-$(LAME_VERSION) && \
	emconfigure ./configure \
		--prefix="$(WORK_PATH)/build/dist" \
		--host=x86-none-linux \
		--disable-static \
		--disable-gtktest \
		--disable-analyzer-hooks \
		--disable-decoder \
		--disable-frontend \
		&& \
	emmake make -j8 && \
	emmake make install

build/dist/lib/libfdk-aac.so:
	cd build/fdk-aac-$(FDKAAC_VERSION) && \
	emconfigure ./configure \
		--prefix="$(WORK_PATH)/build/dist" \
		--host=x86-none-linux \
		--disable-static \
		&& \
	emmake make -j8 && \
	emmake make install


build/dist/lib/libx264.so:
	cd build/x264-$(X264_VERSION) && \
	emconfigure ./configure \
		--prefix="$(WORK_PATH)/build/dist" \
		--host=x86-none-linux \
		--disable-cli \
		--disable-static \
		--enable-shared \
		--disable-opencl \
		--disable-thread \
		--disable-asm \
		\
		--disable-avs \
		--disable-swscale \
		--disable-lavf \
		--disable-ffms \
		--disable-gpac \
		--disable-lsmash \
		&& \
	emmake make -j8 && \
	emmake make install

#webm share lib 
build/dist/lib/libfreetype.so: 
	cd build/freetype-$(FREETYPE_VERSION) && ./autogen.sh && \
	emconfigure ./configure \
		CFLAGS=-O3 \
		--prefix="$(WORK_PATH)/build/dist" \
		--host=x86-none-linux \
		--build=x86_64 \
		--disable-static \
		\
		--without-zlib \
		--without-bzip2 \
		--without-png \
		--without-harfbuzz \
		&& \
	emmake make -j8 && \
	emmake make install

build/dist/lib/libfribidi.so: 
	cd build/fribidi-$(FRIBIDI_VERSION) && ./autogen.sh && \
	emconfigure ./configure \
		CFLAGS=-O3 \
		NM=llvm-nm \
		--prefix="$(WORK_PATH)/build/dist" \
		--host=x86-none-linux \
		--disable-dependency-tracking \
		--disable-debug \
		--without-glib \
		&& \
	emmake make -j8 && \
	emmake make install

build/dist/lib/libass.so: $(LIBASS_DEPS)
	cd build/libass-$(LIBASS_VERSION) && \
	EM_PKG_CONFIG_PATH=$(FFMPEG_PKG_PATH) emconfigure ./configure \
		CFLAGS=-O3 \
		--prefix="$(WORK_PATH)/build/dist" \
		--disable-static \
		--disable-enca \
		--disable-fontconfig \
		--disable-require-system-font-provider \
		--disable-harfbuzz \
		--disable-asm \
		&& \
	emmake make -j8 && \
	emmake make install

build/dist/lib/libopus.so: 
	cd build/opus-$(OPUS_VERSION) && ./autogen.sh && \
	emconfigure ./configure \
		CFLAGS=-O3 \
		--prefix="$(WORK_PATH)/build/dist" \
		--disable-static \
		--disable-doc \
		--disable-extra-programs \
		--disable-asm \
		--disable-rtcd \
		--disable-intrinsics \
		&& \
	emmake make -j8 && \
	emmake make install

build/dist/lib/libvpx.so:
	cd build/libvpx-$(LIBVPX_VERSION) && \
	emconfigure ./configure \
		--prefix="$(WORK_PATH)/build/dist" \
		--target=generic-gnu \
		--disable-dependency-tracking \
		--disable-multithread \
		--disable-runtime-cpu-detect \
		--enable-shared \
		--disable-static \
		\
		--disable-examples \
		--disable-docs \
		--disable-unit-tests \
		--disable-webm-io \
		--disable-libyuv \
		--disable-vp8-decoder \
		--disable-vp9 \
		&& \
	emmake make -j8 && \
	emmake make install



#common ffmpeg filter and demuxer and decoder
COMMON_FILTERS = aresample scale crop overlay
COMMON_DEMUXERS = matroska ogg avi mov flv mpegps image2 mp3 aac adts ac3 wav concat
COMMON_DECODERS = \
	vp8 vp9 theora \
	mpeg2video mpeg4 h264 hevc \
	png mjpeg \
	vorbis opus \
	mp3 ac3 aac \
	pcm_s16le pcm_s16be\
	ass ssa srt webvtt

FFMPEG_COMMON_ARGS = \
	--cc=emcc \
	--enable-cross-compile \
	--target-os=none \
	--target-os=none \
	--arch=x86 \
	--disable-runtime-cpudetect \
	--disable-asm \
	--disable-fast-unaligned \
	--disable-pthreads \
	--disable-w32threads \
	--disable-os2threads \
	--disable-debug \
	--disable-stripping \
	\
	--disable-all \
	--enable-ffmpeg \
	--enable-avcodec \
	--enable-avformat \
	--enable-avutil \
	--enable-swresample \
	--enable-swscale \
	--enable-avfilter \
	--disable-d3d11va \
	--disable-network \
	--disable-dxva2 \
	--disable-vaapi \
	--disable-vdpau \
	$(addprefix --enable-decoder=,$(COMMON_DECODERS)) \
	$(addprefix --enable-demuxer=,$(COMMON_DEMUXERS)) \
	--enable-protocol=file \
	$(addprefix --enable-filter=,$(COMMON_FILTERS)) \
	--disable-bzlib \
	--disable-iconv \
	--disable-libxcb \
	--disable-lzma \
	--disable-sdl2 \
	--disable-securetransport \
	--disable-xlib \
	--disable-zlib

MP4_ENCODERS = libx264 libmp3lame aac libfdk_aac pcm_s16le pcm_s16be
MP4_MUXERS = mp4 mp3 adts wav null
MP4_ARGS = \
	--enable-gpl \
	--enable-libmp3lame \
	--enable-libfdk-aac \
	--enable-libx264 

WEBM_ENCODERS = libvpx_vp8 libopus mjpeg
WEBM_MUXERS = webm ogg null image2
WEBM_ARGS = \
	--enable-filter=subtitles \
	--enable-libass \
	--enable-libopus \
	--enable-libvpx 

ALL_ENCODERS = $(MP4_ENCODERS) \
			   $(WEBM_ENCODERS)
ALL_MUXERS = $(MP4_MUXERS) \
			 $(WEBM_MUXERS)


ffmpeg: $(SOURCE_REDAY) $(SHARED_DEPS) 
	cd build/ffmpeg-$(FFMPEG_VERSION) && \
	EM_PKG_CONFIG_PATH=$(FFMPEG_PKG_PATH) emconfigure ./configure \
		$(FFMPEG_COMMON_ARGS) \
		$(addprefix --enable-encoder=,$(ALL_ENCODERS)) \
		$(addprefix --enable-muxer=,$(ALL_MUXERS)) \
		$(MP4_ARGS) \
		$(WEBM_ARGS) \
		--enable-nonfree \
		--extra-cflags="-I../dist/include" \
		--extra-ldflags="-L../dist/lib" \
		&& \
	emmake make && \
	cp ffmpeg ../ffmpeg.bc 


ffmpeg-mp4: $(SOURCE_REDAY) $(SHARED_DEPS) 
	cd build/ffmpeg-mp4-$(FFMPEG_VERSION) && \
	EM_PKG_CONFIG_PATH=$(FFMPEG_PKG_PATH) emconfigure ./configure \
		$(FFMPEG_COMMON_ARGS) \
		$(addprefix --enable-encoder=,$(MP4_ENCODERS)) \
		$(addprefix --enable-muxer=,$(MP4_MUXERS)) \
		$(MP4_ARGS) \
		--enable-nonfree \
		--extra-cflags="-I../dist/include" \
		--extra-ldflags="-L../dist/lib" \
		&& \
	emmake make && \
	cp ffmpeg ../ffmpeg-mp4.bc 

ffmpeg-webm: $(SOURCE_REDAY) $(SHARED_DEPS) 
	cd build/ffmpeg-webm-$(FFMPEG_VERSION) && \
	EM_PKG_CONFIG_PATH=$(FFMPEG_PKG_PATH) emconfigure ./configure \
		$(FFMPEG_COMMON_ARGS) \
		$(addprefix --enable-encoder=,$(WEBM_ENCODERS)) \
		$(addprefix --enable-muxer=,$(WEBM_MUXERS)) \
		$(WEBM_ARGS) \
		--enable-nonfree \
		--extra-cflags="-I../dist/include" \
		--extra-ldflags="-L../dist/lib" \
		&& \
	emmake make && \
	cp ffmpeg ../ffmpeg-webm.bc 


#EMCC_COMMON_ARGS = \
	#--closure 1 \
	#-s TOTAL_MEMORY=67108864 \
	#-s OUTLINING_LIMIT=20000 \
	#-s NO_EXIT_RUNTIME=0 \
	#-O3 --memory-init-file 0 \
	#-o $@

#EMCC_COMMON_ARGS = \
	#-s TOTAL_MEMORY=134217728\
	#-O2 \
	#-s WASM=0 \
	#-o $@

EMCC_COMMON_ARGS = \
	--closure 1 \
	-s TOTAL_MEMORY=134217728 \
	-O3 \
	-s WASM=0 \
	-o $@

ffmpeg.js: #ffmpeg 
	emcc build/ffmpeg.bc $(SHARED_DEPS) \
		--pre-js pre.js \
		--post-js post.js \
		$(EMCC_COMMON_ARGS)

ffmpeg-worker.js: #ffmpeg 
	emcc build/ffmpeg.bc $(SHARED_DEPS) \
		--pre-js pre-worker.js \
		--post-js post-worker.js \
		$(EMCC_COMMON_ARGS)

ffmpeg-mp4.js: #ffmpeg-mp4
	emcc build/ffmpeg-mp4.bc $(MP4_SHARED_DEPS) \
		--pre-js pre.js \
		--post-js post.js \
		$(EMCC_COMMON_ARGS)

ffmpeg-mp4-worker.js: #ffmpeg-mp4
	emcc build/ffmpeg-mp4.bc $(MP4_SHARED_DEPS) \
		--pre-js pre-worker.js \
		--post-js post-worker.js \
		$(EMCC_COMMON_ARGS)

ffmpeg-webm.js: ffmpeg-webm
	emcc build/ffmpeg-webm.bc $(WEBM_SHARED_DEPS) \
		--pre-js pre.js \
		--post-js post.js \
		$(EMCC_COMMON_ARGS)

ffmpeg-webm-worker.js: ffmpeg-webm
	emcc build/ffmpeg-webm.bc $(WEBM_SHARED_DEPS) \
		--pre-js pre-worker.js \
		--post-js post-worker.js \
		$(EMCC_COMMON_ARGS)


