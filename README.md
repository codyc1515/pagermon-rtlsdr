PagerMon client for RTL-SDR

Docker Compose

version: '3.3'
services:
    pagermon:
        container_name: pagermon
        restart: unless-stopped
        environment:
            - TZ=Pacific/Auckland
        volumes:
            - '/var/lib/pagermon:/config'
        ports:
            - '3000:3000'
        image: 'pagermon/pagermon:latest-armhf'

    pagermon-client:
        volumes:
            - '/var/lib/pagermon/client:/pagermon/client/config'
        container_name: pagermon-client
        devices:
            - /dev/bus/usb
        network_mode: host
        image: pagermon-client:latest

