FROM openjdk:8-jdk
MAINTAINER Dong Hoang <donghoang.nguyen@outlook.com>

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
RUN git clone https://github.com/mipmip/blackbox \
	&& cd blackbox \
	&& make manual-install
RUN cd /opt/android-sdk-linux && \
	wget -q --output-document=sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
	unzip sdk-tools.zip && \
	rm -f sdk-tools.zip && \
	echo y | sdkmanager "build-tools;26.0.2" \
	"platforms;android-25" \
	"build-tools;28.0.3" \
	"platforms;android-27" && \
	sdkmanager "cmake;3.6.4111459"
RUN cd /opt &&\
	wget -q --output-document=android-ndk.zip https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip && \
	unzip android-ndk.zip && \
	rm -f android-ndk.zip && \
	mv android-ndk-r18b android-ndk-linux
RUN apt-get remove -y build-essential git && apt autoremove -y
