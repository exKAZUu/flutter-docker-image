FROM runmymind/docker-android-sdk
MAINTAINER Kazunori Sakamoto

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

RUN apt update \
  && apt dist-upgrade -y \
  && apt install -y tzdata build-essential curl wget dirmngr zip unzip dos2unix \
  && apt update \
  && apt dist-upgrade -y \
  && apt purge -y man \
  && apt autoremove -y \
  && apt clean -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* \
  && curl -s https://get.sdkman.io | bash \
  && echo 'export SDKMAN_DIR="/root/.sdkman"' >> ~/.profile \
  && echo '[[ -s "/root/.sdkman/bin/sdkman-init.sh" ]] && source "/root/.sdkman/bin/sdkman-init.sh"' >> ~/.profile \
  && bash -l -c " \
    yes | sdk install java \
    && sdk install gradle \
  " \
  && wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.2.1-stable.tar.xz \
  && tar xf flutter*.tar.xz \
  && echo 'export PATH="$PATH:/root/flutter/bin"' >> .profile \
  && bash -l -c " \
    flutter precache \
    && flutter doctor \
  " \
  && echo 'export PATH="$PATH:/root/flutter/bin"' >> .profile \
  && echo 'export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"' >> .profile \
  && rm -Rf ~/.sdkman/archives/* ~/.sdkman/tmp/*
