FROM openjdk:8-jdk
MAINTAINER Hoang Rio <donghoang.nguyen@outlook.com>

RUN mkdir -p /opt/android-sdk-linux && mkdir -p ~/.android && touch ~/.android/repositories.cfg
WORKDIR /opt

ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}:${ANDROID_HOME}/tools
ENV ANDROID_NDK /opt/android-ndk-linux
ENV ANDROID_NDK_HOME /opt/android-ndk-linux

RUN apt-get update && apt-get install -y --no-install-recommends \
	unzip \
	wget \
	gnupg2 \
	build-essential \
	git
RUN git clone https://github.com/StackExchange/blackbox \
	&& cd blackbox \
	&& make manual-install
RUN cd /opt/android-sdk-linux && \
	wget -q --output-document=sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip && \
	unzip sdk-tools.zip && \
	rm -f sdk-tools.zip && \
	echo y | sdkmanager --sdk_root=${ANDROID_HOME} "build-tools;29.0.3" \
	"platforms;android-29" \
	"build-tools;28.0.3" \
	"platforms;android-27" && \
	sdkmanager --sdk_root=${ANDROID_HOME} "cmake;3.6.4111459"
