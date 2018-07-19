FROM store/oracle/serverjre:8

MAINTAINER Sven Vollbehr <sven@vollbehr.eu>

ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex \
	&& echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt-unifi.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50 \
	&& apt-get -y update \
	&& apt-get install -y --no-install-recommends c-certificates \
	&& apt-get install -y --no-install-recommends unifi

VOLUME ["/unifi", "/var/run/unifi"]

EXPOSE 3478/udp 6789/tcp 8080/tcp 8443/tcp 8843/tcp 8880/tcp

WORKDIR /unifi

ENTRYPOINT ["/usr/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar"]

CMD ["start"]
