FROM yglukhov/nim-ui-base
MAINTAINER Yuriy Glukhov <yuriy.glukhov@gmail.com>
RUN apt-get install -y libopenal-dev libgtk-3-dev libav-tools iceweasel \
        default-jre-headless s3cmd unzip android-tools-adb ant default-jdk \
    && echo 'Yes, do as I say!' | apt-get -t unstable install -y --force-yes libsdl2-dev \
    && apt-get clean \
    && curl -O http://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip \
    && unzip android-ndk-r11c-linux-x86_64.zip \
    && rm android-ndk-r11c-linux-x86_64.zip \
    && curl -O https://www.libsdl.org/release/SDL2-2.0.4.zip \
    && unzip SDL2-2.0.4.zip \
    && rm SDL2-2.0.4.zip \
    && curl -O http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz \
    && tar xf android-sdk_r24.4.1-linux.tgz \
    && rm android-sdk_r24.4.1-linux.tgz \
    && mkdir -p ~/Library/Android \
    && mkdir -p ~/Projects \
    && mv android-sdk-linux ~/Library/Android/sdk \
    && mv android-ndk-r11c ~/Library/Android/sdk/ndk-bundle \
    && mv SDL2-2.0.4 ~/Projects/SDL \
    && rm -rf /var/lib/apt/lists/*
