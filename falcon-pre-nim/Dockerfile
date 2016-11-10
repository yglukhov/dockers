FROM debian:stretch
MAINTAINER Yuriy Glukhov <yuriy.glukhov@gmail.com>

ADD run.sh /bin/run
ADD 005-nim-version.sh /onStart.d/005-nim-version.sh

ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/ \
    DISPLAY=:1.0 \
    PATH=$PATH:/nim/bin:/root/.nimble/bin:/emscripten

ADD innerbuild.sh /bin/innerbuild.sh
RUN . /bin/innerbuild.sh
