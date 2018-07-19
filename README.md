# Dockerfile for Ubiquiti UniFi Controller

Dockerfile for deploying Ubiquiti UniFi Controller in a container.

## Configuration

* Debian Stretch (debian/stretch-slim)
* Oracle Java JRE (8u181)
* UniFi Controller (stable)

## Build Instructions

```
docker build -t vollbehr/private/unifi-controller:0.9 -t vollbehr/private/unifi-controller:latest .
```

## Run Instructions

```
docker run --cap-drop ALL -d -p 1900:1900 -p 3478:3478 -p 6789:6789 -p 8080:8080 -p 8443:8443 -p 8880:8880 -p 10001:10001 -v unifi-data:/usr/lib/unifi/data -v unifi-logs:/usr/lib/unifi/logs --name unifi vollbehr/private/unifi-controller
```

### Ports
* 1900/udp
* 3478/tcp
* 6789/tcp
* 8080/tcp
* 8443/tcp
* 8880/tcp
* 10001/udp

See also https://help.ubnt.com/hc/en-us/articles/218506997-UniFi-Ports-Used.

### Volumes
* /usr/lib/unifi/data
* /usr/lib/unifi/logs

### Parameters
* JVM_EXTRA_OPTS
