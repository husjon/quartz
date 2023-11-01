---
created: 2023-07-24T16:25:18+02:00
updated: 2023-11-01T21:46:55+01:00
title: Creality K1 and MQTT
tags:
  - creality
  - 3d_printing
  - hacking
publish: true
---
## Introduction
Back in June we were able to get into the Creality K1 linux environment with an exploit made public by K3D[^k3d] and translated by 3DPrintSOS[^3dprintsos].  
With this exploit we were able to get the Fluidd[^fluidd] web interface up and running in parallel with Crealitys increadibly limited web interface.

I decided to create a simple script to make it a quick one-shot install, located in my GitHub Repository[^github_repo]
The script can be used by:
1. SSH onto the printer (`root:0755cxsw$888`)
2. Run: `wget https://github.com/husjon/creality-k1/raw/main/enable_fluidd.sh -O - | sh`
It will enable Fluidd then reboot the printer and finally print out the address of the Fluidd webinterface.

## Discovery
After some more poking around I found that the machine is also calling home using MQTT.
![[../public/images/creality_k1_mqtt_connection.png]]
**Note**: In my case I've already blocked it hence the `SYS-SENT` state.

The address seem to be owned by Alibaba.com LLC and located in Charlottesville, Virginia, United States (see: https://db-ip.com/47.253.214.226).  
The server itself requires authentication.  
~~I've yet to be able to locate the credentials and I've not yet done any packet captures.~~

## Update
### 2023.07.24
After some more more poking around and doing a packet capture it seem to not use a password to connect. 
The only thing I can see that it uses is a Client ID and a Username.
~~Since I'm not entirely sure if~~ the username is on a per machine I've blurred it out partially.
![[../public/images/creality_k1_mqtt_packet_capture.png]]

Using the paho mqtt library for python I was able to connect and confirm that the username is tied to the machine as once I allowed the printer to connect my paho connection was dropped.


After the connection is established the following topics are subscribed to and published to:
Subscriptions:
* **v1/devices/me/attributes/response/+**
* **v1/devices/me/rpc/request/+**

Publish:
* **v1/devices/me/telemetry**
  ```json
  {
      "nozzleTemp": 0,
      "bedTemp": 0,
      "boxTemp": 0,
      "printProgress": 0,
      "printJobTime": 0,
      "printLeftTime": 0,
      "dProgress": 0,
      "curFeedratePct": 0,
      "curFlowratePct": 0,
      "ConsumablesLen": 0,
      "curPosition": "X:0.00 Y:0.00 Z:0.00",
      "curHome": "X:0 Y:0 Z:0",
      "layer": 0,
      "FilamentLen": 0
  }
  ```
* **v1/devices/me/attributes**
  ```json
  {
      "connect": 0,
      "tfCard": 0,
      "modelVersion": "printer hw ver:CR4CU220812S11;printer sw ver:1.2.9.15;DWIN hw ver:;DWIN sw ver:;",
      "model": "CR-K1",
      "state": 0,
      "printId": "",
      "modelFan": 0,
      "caseFan": 0,
      "auxiliaryFan": 0,
      "modelFanPct": 0,
      "caseFanPct": 0,
      "auxiliaryFanPct": 0,
      "nozzleTemp2": 0,
      "bedTemp2": 0,
      "TotalLayer": 0,
      "printStartTime": 0,
      "repoPlrStatus": 0,
      "upgradeStatus": 0,
      "videoElapse": 1,
      "nozzleMoveSnapshot": 0,
      "led_state": 1,
      "video": 0,
      "video1": 0,
      "enableAITest": 0,
      "enableFaultStop": 0,
      "firstFaultReminder": 0,
      "zOffset": "0.000",
      "autoLeveling": 0,
      "chatteringOpt": 0,
      "enableSelfTest": 0,
      "withSelfTest": 0,
      "feedState": 0,
      "feedStateTemp2": 0,
      "speedMode": 0,
      "printerVersion": "1.2.9.15"
  }
  
  ```

These are all placeholder values when it initially calls home, after which when you start using the printer (homing etc) it starts sending more telemetry information.

## Assumptions and thoughts
My assumption is that it is tied to the Creality Cloud platform allowing the user to control their printer from their phone.  
However, even if the printer is not set to connect to this platform or in their words Bind the printer (from the touch screen menus) it is still connected to their MQTT server and starts sending all this data.  
Since I do not intend on using their application or platform I've blocked it in my network.


## Open Source Firmware
Creality has announced that they will be releasing an open source firmware in Septempber[^creality_twitter_opensource] I will do a follow-up when that has been released.
![[../public/images/creality_k1_k1max_opensource_announcement.png]]

[^fluidd]: https://docs.fluidd.xyz/
[^k3d]: https://www.youtube.com/watch?v=D8qqrK7eC1E (K3D)
[^3dprintsos]: https://www.youtube.com/watch?v=sZJjOkQJVSQ (3DPrintSOS)
[^github_repo]: https://github.com/husjon/creality-k1
[^creality_twitter_opensource]: https://twitter.com/Creality3dP/status/1682342838586204166