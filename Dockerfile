FROM debian:stretch-slim

MAINTAINER Sven Vollbehr

ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN set -ex \
	&& apt-get update && apt-get install -y --no-install-recommends wget gnupg dirmngr procps \
	&& if [ ! -d /usr/share/man/man1 ]; then \
	     mkdir -p /usr/share/man/man1; \
		 fi \
	&& useradd -U unifi -s /bin/bash -r -m -l -d /var/lib/unifi

ENV LANG=C.UTF-8

# Install Java 8u181
RUN set -ex \
	&& sed -i 's/stretch main/stretch main contrib/' /etc/apt/sources.list \
	&& apt-get -q update && apt-get -q install -y --no-install-recommends java-common java-package \
 	&& wget --quiet --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jre-8u181-linux-x64.tar.gz \
			-O /tmp/jre-8u181-linux-x64.tar.gz \
	&& runuser -l unifi -c "cd /tmp && yes Y | fakeroot make-jpkg /tmp/jre-8u181-linux-x64.tar.gz" \
	&& dpkg -i /tmp/oracle-java8-jre_8u181_amd64.deb \
	&& sed -i 's/stretch main contrib/stretch main/' /etc/apt/sources.list

# Install Ubiquiti UniFi Controller
RUN set -ex \
	&& chsh unifi --shell /bin/false \
	&& echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt-unifi.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50 \
	&& apt-get -q update && apt-get -q install -y --no-install-recommends unifi
RUN set -ex \
	&& mkdir -p /usr/lib/unifi/data /usr/lib/unifi/logs /usr/lib/unifi/run \
	&& chown unifi.unifi /usr/lib/unifi/data /usr/lib/unifi/logs /usr/lib/unifi/run

# Clean-up
RUN set -ex \
	&& apt-get -q update \
	&& apt-get -y remove wget \
	&& apt-get -y remove java-package \
	&& apt-get -y --purge autoremove \
	&& apt-get -y clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/*

ENV JVM_OPTS=${JVM_EXTRA_OPTS:--Xmx1024M} -Djava.awt.headless=true -Dfile.encoding=UTF-8

USER unifi

EXPOSE 1900/udp 3478/udp 6789/tcp 8080/tcp 8443/tcp 8843/tcp 8880/tcp 10001/udp

VOLUME /usr/lib/unifi/data
VOLUME /usr/lib/unifi/logs

WORKDIR /usr/lib/unifi

ENTRYPOINT /usr/bin/java ${JVM_OPTS} -jar /usr/lib/unifi/lib/ace.jar start
