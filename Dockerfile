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
  && rm -Rf ~/.sdkman/archives/* ~/.sdkman/tmp/*
