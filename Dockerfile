FROM runmymind/docker-android-sdk
MAINTAINER Kazunori Sakamoto

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
ENV FLUTTER_VERSION 1.2.1
ENV AVD_NAME="384x640_mdpi_api_23"
ENV CREATE_AVD_COMMAND="android create avd \
 --name ${AVD_NAME} \
 --target android-28 \
 --skin 384x640 \
 --abi google_apis/x86_64 \
 --force"

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
  && echo 'export PATH="$PATH:/root/flutter/bin"' >> .profile \
  && echo 'export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"' >> .profile \
  && bash -l -c " \
    flutter upgrade \
    && flutter precache \
    && git clone https://github.com/exKAZUu/integration_test_sample.git \
    && cd integration_test_sample \
    && flutter packages get \
    && flutter test \
    && flutter emulators \
    && emulator -list-avds \
    && sdkmanager tools \
    && flutter drive --target=test_driver/app.dart \
    && cd .. \
    && rm -Rf integration_test_sample \
  "

ENV PATH $PATH:/root/flutter/bin
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
