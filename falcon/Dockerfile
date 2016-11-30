FROM yglukhov/falcon-pre-nim
MAINTAINER Yuriy Glukhov <yuriy.glukhov@gmail.com>

# nim-base
RUN git clone -b ssl-init-fix --depth 1 https://github.com/yglukhov/Nimrod.git \
    && mv Nimrod nim \
    && cd nim \
    && git clone --depth 1 https://github.com/nim-lang/csources.git \
    && cd csources \
    && sh build.sh \
    && cd .. \
    && nim c koch \
    && ./koch boot -d:release \
    && ./koch nimble \
    && cd .. \
    && rm -rf ./nim/nimcache ./nim/compiler/nimcache ./nim/csources
