# PagerMon client for RTL-SDR
Receive and view messages from nearby pager transmitters in a visual web UI using a RTL-SDR receiver.

## Installation
Run the Docker Compose script (below), then browse to HTTP port 3000 on your device.

### Docker Compose
```
version: '3.3'
services:
    pagermon:
        container_name: pagermon
        image: 'pagermon/pagermon:latest-armhf' # For PC: remove :latest-armhf
        restart: unless-stopped
        environment:
            - TZ=Pacific/Auckland
        volumes:
            - '/var/lib/pagermon:/config'
        ports:
            - '3000:3000'
        depends_on:
            - pagermon-client

    pagermon-client:
        build:
            context: https://github.com/codyc1515/pagermon-rtlsdr.git#main
            dockerfile: Dockerfile
        container_name: pagermon-client
        image: pagermon-client:latest
        restart: unless-stopped
        environment:
            - TZ=Pacific/Auckland
        volumes:
            - '/var/lib/pagermon/client:/pagermon/client/config'
        devices:
            - /dev/bus/usb
        network_mode: host
```
