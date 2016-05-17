FROM yglukhov/falcon-pre-nim
MAINTAINER Yuriy Glukhov <yuriy.glukhov@gmail.com>

# nim-base
RUN git clone --depth 1 https://github.com/nim-lang/nim.git \
    && cd nim \
    && sh ./bootstrap.sh \
    && cd - \
    && git clone --depth 1 https://github.com/nim-lang/nimble.git \
    && nim c -r nimble/src/nimble install -y nimble \
    && rm -rf ./nim/nimcache ./nim/compiler/nimcache ./nim/csources ./nimble
