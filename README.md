PagerMon client for RTL-SDR

Docker Build

```docker build -t pagermon-client ~/pagermon-client```

Docker Compose

```
version: '3.3'
services:
    pagermon:
        container_name: pagermon
        image: 'pagermon/pagermon:latest-armhf'
        # For PC: remove :latest-armhf
        restart: unless-stopped
        environment:
            - TZ=Pacific/Auckland
        volumes:
            - '/var/lib/pagermon:/config'
        ports:
            - '3000:3000'

    pagermon-client:
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

