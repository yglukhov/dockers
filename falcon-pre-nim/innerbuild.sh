
set -ev

while ! apt-get update; do true; done
while ! apt-get install -y gcc g++ mercurial git nodejs libopenal-dev libgtk-3-0 libav-tools unzip ant expect \
        default-jdk fonts-dejavu-core xvfb curl libsdl2-dev make cmake libssl-dev pngquant chromium libpng-dev awscli jq; do true; done

mkdir -p /etc/ssh
echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config
mkdir /onStart.d /onQuit.d

echo 'Xvfb :1 -screen 0 1024x768x16 +extension RANDR &' > /onStart.d/010-start-x-server.sh

buildPosterizer() {
    echo "BUILDING POSTERIZER"
    git clone https://github.com/pornel/mediancut-posterizer.git
    cd mediancut-posterizer
    make
    mv ./posterize /bin/
    cd -
    rm -rf mediancut-posterizer
}

buildPngcrush() {
    curl -LO https://sourceforge.net/projects/pmt/files/pngcrush/1.8.11/pngcrush-1.8.11.tar.gz/download
    tar xvf download
    rm download
    cd pngcrush-1.8.11
    make
    mv ./pngcrush /bin/
    cd -
    rm -r pngcrush-1.8.11
}

buildEmscripten() {
    EMSCRIPTEN_VERSION=1.37.1

    echo "DOWNLOADING EMSCRIPTEN: $EMSCRIPTEN_VERSION"
    curl -LO https://github.com/kripken/emscripten/archive/$EMSCRIPTEN_VERSION.tar.gz
    tar -zxf $EMSCRIPTEN_VERSION.tar.gz
    rm $EMSCRIPTEN_VERSION.tar.gz
    mv emscripten-$EMSCRIPTEN_VERSION emscripten
    rm -rf emscripten/tests

    echo "DOWNLOADING EMSCRIPTEN FASTCOMP"
    curl -LO https://github.com/kripken/emscripten-fastcomp/archive/$EMSCRIPTEN_VERSION.tar.gz
    tar -zxf $EMSCRIPTEN_VERSION.tar.gz
    rm $EMSCRIPTEN_VERSION.tar.gz
    mv emscripten-fastcomp-$EMSCRIPTEN_VERSION emscripten-fastcomp

    echo "DOWNLOADING EMSCRIPTEN FASTCOMP CLANG"
    curl -LO https://github.com/kripken/emscripten-fastcomp-clang/archive/$EMSCRIPTEN_VERSION.tar.gz
    tar -zxf $EMSCRIPTEN_VERSION.tar.gz
    rm $EMSCRIPTEN_VERSION.tar.gz
    mv emscripten-fastcomp-clang-$EMSCRIPTEN_VERSION emscripten-fastcomp/tools/clang

    echo "BUILDING EMSCRIPTEN"
    mkdir -p emscripten-fastcomp/build
    cd emscripten-fastcomp/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86;JSBackend" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_TESTS=OFF
    make install
    cd -
    rm -r emscripten-fastcomp

    emcc -v && emcc -v
    python /emscripten/embuilder.py build libc dlmalloc libcxxabi libcxx_noexcept
}

installAndroidBuildEnv() {
    NDK_VERSION=r13b
    NDK_FILE_NAME=android-ndk-$NDK_VERSION
    NDK_ZIP_NAME=$NDK_FILE_NAME-linux-x86_64.zip
    echo "DOWNLOADING ANDROID NDK: $NDK_ZIP_NAME"
    curl -O http://dl.google.com/android/repository/$NDK_ZIP_NAME
    unzip -qq $NDK_ZIP_NAME
    rm $NDK_ZIP_NAME

    echo "DOWNLOADING ANDROID SDK"
    curl -O http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
    tar xf android-sdk_r24.4.1-linux.tgz
    rm android-sdk_r24.4.1-linux.tgz
    mkdir -p ~/Library/Android
    mv android-sdk-linux ~/Library/Android/sdk
    mv $NDK_FILE_NAME ~/Library/Android/sdk/ndk-bundle

    # Install needed sdk packages by using filter. List of possible packages:
    # ~/Library/Android/sdk/tools/android list sdk --extended --all --obsolete
    expect -c '
set timeout -1;
spawn ~/Library/Android/sdk/tools/android update sdk --no-ui --all --filter platform-tools,android-19,android-23,build-tools-25.0.2,extra-android-m2repository,extra-google-m2repository;
expect {
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
}
'
}

installSDL() {
    curl -O https://www.libsdl.org/release/SDL2-2.0.5.tar.gz
    tar xf SDL2-2.0.5.tar.gz
    rm SDL2-2.0.5.tar.gz
}

cleanup() {
    echo "CLEANUP"
    apt-get remove -y cmake curl g++ libpng-dev unzip expect
    apt-get autoremove -y
    apt-get clean all
    rm -rf /var/lib/apt/lists/*
    rm -rf /usr/share/doc
    rm -rf /usr/share/man
    rm -rf /usr/share/locale
    rm -rf /bin/innerbuild.sh
}

buildPosterizer
installSDL
buildPngcrush
buildEmscripten
installAndroidBuildEnv
cleanup
