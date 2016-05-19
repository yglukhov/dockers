FROM debian:stable
MAINTAINER Yuriy Glukhov <yuriy.glukhov@gmail.com>

ADD run.sh /bin/run
ADD 005-nim-version.sh /onStart.d/005-nim-version.sh

ENV EMSCRIPTEN_VERSION=1.36.4 \
    LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/ \
    DISPLAY=:1.0 \
    PATH=$PATH:/nim/bin:/root/.nimble/bin:/emscripten

RUN echo deb http://http.debian.net/debian jessie-backports main contrib non-free >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y gcc g++ mercurial git nodejs libopenal-dev libgtk-3-0 libav-tools iceweasel \
        s3cmd unzip default-jdk fonts-dejavu-core xvfb cmake curl libxext-dev \
    && echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config \
    && mkdir /onQuit.d \
    && echo 'Xvfb :1 -screen 0 1024x768x16 +extension RANDR &' > /onStart.d/010-start-x-server.sh \
    \
    && echo "DOWNLOADING SDL" \
    && curl -O https://www.libsdl.org/release/SDL2-2.0.4.zip \
    && unzip -qq SDL2-2.0.4.zip \
    && rm SDL2-2.0.4.zip \
    \
    && mkdir -p ~/Projects \
    && mv SDL2-2.0.4 ~/Projects/SDL \
    \
    && echo "BUILDING SDL" \
    && cd ~/Projects/SDL \
    && ./configure --disable-video-wayland && make install && make clean && cd - \
    && rm -rf ~/Projects/SDL/test \
    \
    && echo "DOWNLOADING EMSCRIPTEN" \
    && curl -LO https://github.com/kripken/emscripten/archive/$EMSCRIPTEN_VERSION.tar.gz \
    && tar -zxf $EMSCRIPTEN_VERSION.tar.gz \
    && rm $EMSCRIPTEN_VERSION.tar.gz \
    && mv emscripten-$EMSCRIPTEN_VERSION emscripten \
    && rm -rf emscripten/tests \
    \
    && echo "DOWNLOADING EMSCRIPTEN FASTCOMP" \
    && curl -LO https://github.com/kripken/emscripten-fastcomp/archive/$EMSCRIPTEN_VERSION.tar.gz \
    && tar -zxf $EMSCRIPTEN_VERSION.tar.gz \
    && rm $EMSCRIPTEN_VERSION.tar.gz \
    && mv emscripten-fastcomp-$EMSCRIPTEN_VERSION emscripten-fastcomp \
    \
    && echo "DOWNLOADING EMSCRIPTEN FASTCOMP CLANG" \
    && curl -LO https://github.com/kripken/emscripten-fastcomp-clang/archive/$EMSCRIPTEN_VERSION.tar.gz \
    && tar -zxf $EMSCRIPTEN_VERSION.tar.gz \
    && rm $EMSCRIPTEN_VERSION.tar.gz \
    && mv emscripten-fastcomp-clang-$EMSCRIPTEN_VERSION emscripten-fastcomp/tools/clang \
    \
    && echo "BUILDING EMSCRIPTEN" \
    && mkdir -p emscripten-fastcomp/build \
    && cd emscripten-fastcomp/build \
    && cmake .. -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86;JSBackend" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_TESTS=OFF \
    && make install \
    && cd - \
    && rm -r emscripten-fastcomp \
    \
    && echo "CLEANUP" \
    && apt-get remove -y unzip cmake curl libxext-dev g++ \
    && apt-get autoremove -y \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc \
    && rm -rf /usr/share/man \
    && rm -rf /usr/share/locale \
    && emcc

# && echo "DOWNLOADING ANDROID NDK" \
# && curl -O http://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip \
# && unzip -qq android-ndk-r11c-linux-x86_64.zip \
# && rm android-ndk-r11c-linux-x86_64.zip \
# \
# && echo "DOWNLOADING ANDROID SDK" \
# && curl -O http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz \
# && tar xf android-sdk_r24.4.1-linux.tgz \
# && rm android-sdk_r24.4.1-linux.tgz \
# && mkdir -p ~/Library/Android \
# && mv android-sdk-linux ~/Library/Android/sdk \
# && mv android-ndk-r11c ~/Library/Android/sdk/ndk-bundle \
