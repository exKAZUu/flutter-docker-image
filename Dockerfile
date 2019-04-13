FROM runmymind/docker-android-sdk
MAINTAINER Kazunori Sakamoto

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Tokyo
ENV FLUTTER_VERSION 1.2.1
ENV AVD_NAME Nexus5
ENV IMAGE_NAME system-images;android-25;google_apis;armeabi-v7a
ENV DEVICE_ID 16

RUN apt-get update -q \
  && echo 'export PATH="$PATH:/root/flutter/bin"' >> ~/.profile \
  && echo 'export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"' >> ~/.profile \
  && bash -l -c ' \
    avdmanager list \
    && sdkmanager "$IMAGE_NAME" \
    && sdkmanager --licenses \
    && avdmanager create avd -n "$AVD_NAME" -k "$IMAGE_NAME" -d "$DEVICE_ID" \
    && emulator -avd "$AVD_NAME" -no-skin -no-audio -no-window \
  ' \
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
  && bash -l -c ' \
    flutter upgrade \
    && flutter precache \
    && git clone https://github.com/exKAZUu/integration_test_sample.git \
    && cd integration_test_sample \
    && flutter packages get \
    && flutter test \
    && sdkmanager --list \
    && flutter emulators \
    && emulator -list-avds \
    && flutter drive --target=test_driver/app.dart \
    && cd .. \
    && rm -Rf integration_test_sample \
  '

ENV PATH $PATH:/root/flutter/bin
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
