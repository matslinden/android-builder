FROM openjdk:8-jdk

ENV ANDROID_ARCHIVE "sdk-tools-linux-4333796.zip"
ENV ANDROID_URL "https://dl.google.com/android/repository/${ANDROID_ARCHIVE}"
ENV ANDROID_SDK_VOLUME /home/android
ENV ANDROID_SDK_ROOT $ANDROID_SDK_VOLUME/sdk
# deprecated, use ANDROID_SDK_ROOT
ENV ANDROID_HOME $ANDROID_SDK_ROOT

ENV PATH "$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y  \
         lib32gcc1 \
         lib32ncurses5 \
         lib32stdc++6 \
         lib32z1 \
         libc6-i386 \
         gosu \
         unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint /

ENV JAVA_TOOL_OPTIONS "-Duser.home=$ANDROID_SDK_VOLUME"
VOLUME $ANDROID_SDK_VOLUME
ENTRYPOINT [ "/entrypoint" ]
