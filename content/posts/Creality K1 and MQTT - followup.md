---
title: Creality K1 and MQTT
enableToc: true
tags:
  - creality
  - 3d_printing
  - hacking
  - followup
created: 2023-09-17T15:49:08+02:00
updated: 2023-09-17T19:12:48+02:00
---
## Introduction
This is a followup to [[Creality K1 and MQTT]].
TLDR; The MQTT client is not connected to the external MQTT server by default.


## Preparation
Yesterday I upgraded my K1 from `v1.2.9.15`, which I've been running ever since my last writeup.
I refused to upgrade since Creality decided to remove all access and fluidd from the firmware, also since their [[Creality K1 and MQTT#Open Source Firmware|Open Source firmware announcement]] I knew it wouldn't be too long until I could upgrade anyways.

Prior to upgrading I made a backup of my config, then reset the printer to factory defaults.
I was not able to upgrade directly to `v1.3.2.1` so I had to follow the upgrade path: `v1.2.9.15` -> `v1.2.9.22` -> `v1.3.1.4` -> `v1.3.1.28` -> `v1.3.2.1`.
I might have been able to skip one or two of them, but I did this so that I hit each minor / patch breakpoints (just to be on the safe side). 

### Rooting
I then followed the [K1 Series root tutorial.pdf](https://github.com/husjon/K1_Series_Annex/blob/main/root%20guide/K1%20Series%20root%20tutorial.pdf) that Creality provided.
In short:
  1. Upgrade firmware to `v1.3.2.1` or later
  2. Run through the Initial setup procedure (self-check including bed leveling and input shaping)
  3. Once the printer is ready, I head over to **Settings** and clicked **Root Access Information**
       You'll be shown a disclaimer which you have to agree to (you also have to wait 30 seconds for the timer to run out).
  4. Once you click confirm, the credentials are shown
       User: `root`
       Password: `creality_2023`

## Webinterface
Once the the printer has been rooted, we just need to install the web interface of choice ([Fluidd](https://docs.fluidd.xyz/) or [Mainsail](https://docs.mainsail.xyz/)).
I decided to go for fluidd since that's what I'm used to.

### Setting up Fluidd
1. Log onto the printer with SSH using the credentials we got from [[#Rooting]]
2. Change directory to `/usr/data`:
   * `cd /usr/data`
3. Download the setup script and tarball:
* `wget https://raw.githubusercontent.com/CrealityOfficial/K1_Series_Annex/main/fluidd/fluidd/fluidd.sh`
* `wget https://raw.githubusercontent.com/CrealityOfficial/K1_Series_Annex/main/fluidd/fluidd/fluidd.tar`
4. Run the setup script:
   * `sh fluidd.sh`
5. After the files been extracted, it will start the services and the web interface will be available within a few seconds.
   * `http://PRINTER_IP:4408`
   
### Setting up Mainsail
1. Log onto the printer with SSH using the credentials we got from [[#Rooting]]
2. Change directory to `/usr/data`:
   * `cd /usr/data`
3. Download the setup script and tarball:
* `wget https://raw.githubusercontent.com/CrealityOfficial/K1_Series_Annex/main/mainsail/mainsail/mainsail.sh`
* `wget https://raw.githubusercontent.com/CrealityOfficial/K1_Series_Annex/main/mainsail/mainsail/mainsail.tar`
4. Run the setup script:
   * `sh fluidd.sh`
5. After the files been extracted, it will start the services and the web interface will be available within a few seconds.
   * `http://PRINTER_IP:4409`


## Checking what is running on the printer
This is mainly what my followup is all about.

```
root@creality /root [#] ps aux | grep -Ev '0:.. [\[\{]'
PID   USER     TIME  COMMAND
  707 root      0:00 /sbin/syslogd -n
  711 root      0:00 /sbin/klogd -n
  753 root      0:00 /usr/sbin/ubusd
  757 root      0:00 /usr/bin/device_manager
  995 root      0:00 /usr/bin/boot_display display
  999 root      0:00 /sbin/udevd -d
 1043 root      0:10 /usr/bin/cam_app -i /dev/v4l/by-id/main-video-4 -t 0 -w 1280 -h 720 -f 15 -c
 1050 root      0:03 /usr/bin/mjpg_streamer -i input_memfd.so -t 0 -o output_http.so -w /usr/share/mjpg-streamer/www/ -p 8080
 1199 dbus      0:00 dbus-daemon --system
 1319 root      0:00 /usr/sbin/ifplugd -i eth0 -fI -u0 -d0
 1347 root      0:00 /usr/sbin/ntpd -g
 1348 root      0:00 wpa_supplicant -B -i wlan0 -c /usr/data/wpa_supplicant.conf
 1371 root      0:00 nginx: master process /usr/data/nginx/sbin/nginx -c /usr/data/nginx/nginx/nginx.conf
 1372 www-data  0:00 nginx: worker process
 1405 root      0:17 /usr/share/klippy-env/bin/python /usr/share/klipper/klippy/klippy.py /usr/data/printer_data/config/printer.cfg -l /usr/data/printer_data/logs/klippy.log -a /tmp/klippy_uds
 1409 root      0:09 /usr/data/moonraker/moonraker-env/bin/python /usr/data/moonraker/moonraker/moonraker/moonraker.py -d /usr/data/printer_data
 1413 root      0:00 /usr/bin/klipper_mcu -r
 1417 root      0:03 /usr/bin/cx_ai_middleware
 1419 root      0:00 /usr/bin/wipe_data
 1462 root      0:00 /usr/bin/mdns --service _Creality-5874562800048F._udp.local --port 5353 --hostname creality
 1493 root      0:03 /usr/bin/master-server
 1494 root      0:00 /usr/bin/audio-server
 1495 root      0:00 /usr/bin/wifi-server
 1496 root      0:00 /usr/bin/app-server
 1497 root      0:08 /usr/bin/display-server
 1498 root      0:00 /usr/bin/upgrade-server
 1499 root      0:00 /usr/bin/web-server
 1500 root      0:00 /usr/bin/Monitor
 1501 root      0:00 /sbin/getty -L console 115200 vt100
 1584 root      0:00 udhcpc -i wlan0 -x hostname:creality-048F
 1656 root      0:00 /usr/bin/webrtc 5874562800048F 2
 1684 root      0:00 /usr/sbin/dropbear -R
 1702 root      0:00 /usr/sbin/dropbear -R
 1902 root      0:00 -sh
 4602 root      0:00 ps aux
root@creality /root [#]
```

### Inbound / Outbound Connections
Listing connections which uses either TCP or UDP.
Nothing out of the ordinary.
```
root@creality /root [#] ss -ntpu
Netid     State     Recv-Q     Send-Q          Local Address:Port           Peer Address:Port      Process
tcp       ESTAB     0          0                    10.0.0.6:22               10.0.0.X:53106      users:(("dropbear",pid=1702,fd=7))    <- Connection to SSH
tcp       ESTAB     0          0                    10.0.0.6:4408             10.0.0.X:47290      users:(("nginx",pid=1372,fd=3))       <- Connection to the web interface
```


### Listeners
Here are which ports the printer is listening on.
Nothing out of the ordinary here either.
```
root@creality /root [#] ss -lntpu
Netid   State    Recv-Q   Send-Q     Local Address:Port     Peer Address:Port  Process
udp     UNCONN   0        0               10.0.0.6:123           0.0.0.0:*      users:(("ntpd",pid=1347,fd=21))                             <-+
udp     UNCONN   0        0              127.0.0.1:123           0.0.0.0:*      users:(("ntpd",pid=1347,fd=17))                               |
udp     UNCONN   0        0                0.0.0.0:123           0.0.0.0:*      users:(("ntpd",pid=1347,fd=16))                             <-+--- NTP daemon (listening on all interfaces)
udp     UNCONN   0        0                0.0.0.0:5353          0.0.0.0:*      users:(("mdns",pid=1462,fd=3))                              <----- mDNS
tcp     LISTEN   0        128              0.0.0.0:9999          0.0.0.0:*      users:(("web-server",pid=1499,fd=3))                        <----- Crealitys API (used by their webserver)
tcp     LISTEN   0        128              0.0.0.0:80            0.0.0.0:*      users:(("web-server",pid=1499,fd=7))                        <----- Crealitys Web Interface
tcp     LISTEN   0        10               0.0.0.0:8080          0.0.0.0:*      users:(("mjpg_streamer",pid=1050,fd=4))                     <----- Camera stream
tcp     LISTEN   0        128              0.0.0.0:7125          0.0.0.0:*      users:(("python",pid=1409,fd=15))                           <----- Moonraker
tcp     LISTEN   0        128              0.0.0.0:22            0.0.0.0:*      users:(("dropbear",pid=1684,fd=5))                          <----- SSH (using dropbear)
tcp     LISTEN   0        128              0.0.0.0:4408          0.0.0.0:*      users:(("nginx",pid=1372,fd=10),("nginx",pid=1371,fd=10))   <----- nginx server for Fluidd
tcp     LISTEN   0        128              0.0.0.0:4409          0.0.0.0:*      users:(("nginx",pid=1372,fd=11),("nginx",pid=1371,fd=11))   <----- nginx server for Mainsail (not used in my case)
```


## Final words
My [[Creality K1 and MQTT#Assumptions and thoughts|assumptions]] from the previous write-up was that it was used when using their Mobile App / Slicer / Mobile app.
I'm happy to see that Creality removed the MQTT client from starting up by default.
