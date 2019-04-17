FROM runmymind/docker-android-sdk
MAINTAINER Kazunori Sakamoto

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Tokyo
ENV FLUTTER_VERSION 1.2.1
ENV FLUTTER_CHANNEL beta

RUN apt-get update -q \
  && apt-get dist-upgrade -y -q \
  && apt-get install -y -q tzdata build-essential curl wget dirmngr zip unzip dos2unix \
  && apt-get update -q \
  && apt-get dist-upgrade -y -q \
  && apt-get purge -y -q man \
  && apt-get autoremove -y -q \
  && apt-get clean -y -q \
  && rm -rf /var/lib/apt/lists/* /tmp/* \
  && cd \
  && wget -nv https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v$FLUTTER_VERSION-stable.tar.xz \
  && tar xf flutter*.tar.xz \
  && echo 'export PATH="$PATH:/root/flutter/bin"' >> ~/.profile \
  && echo 'export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"' >> ~/.profile \
  && bash -l -c ' \
    flutter channel $FLUTTER_CHANNEL \
    && flutter upgrade \
    && flutter precache \
  '

ENV PATH $PATH:/root/flutter/bin
ENV PATH $PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
