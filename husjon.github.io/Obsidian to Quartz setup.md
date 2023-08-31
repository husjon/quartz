---
title: Obsidian to Quartz setup
tags:
  - obsidian
  - quartz
  - quartz-v4
created: 2023-08-27T21:41:34+02:00
updated: 2023-08-31T18:56:17+02:00
---

## Introduction
I originally wrote about my [[Obsidian to Quartz setup v3]] at the start of the year, since Quartz v4 is out, here is my current setup.

[Jacky Zhao](https://github.com/jackyzha0) has done amazing work with reducing dependencies of the Quartz project and now uses `npx` to build, publish and do local development instead of previously using a `go` and in particular the `hugo-obsidian` package.

This also reduced the publishing script I created for the previous setup ([[Obsidian to Quartz setup v3#Publishing my notes.|Publishing my notes]]).


## Upgrading
If you're upgrading I would recommend reading the https://quartz.jzhao.xyz/migrating-from-Quartz-3 guide from the documentation.

If you're new to Quartz, check out Getting Started section on https://quartz.jzhao.xyz/



## The Setup
### Folder Structure
My folder structure is similar to my [[Obsidian to Quartz setup v3#Preparing the Obsidian Vault|original writeup]], however it is now moved into `~/Documents/Obsidian` so that everything is grouped together.
* **Main Vault** lives under `~/Documents/Obsidian/Vault`
* **Quartz** lives under `~/Documents/Obsidian/quartz`
* **Quartz** is symlinked into my **Main Vault**  
  `~/Documents/Obsidian/quartz/content -> ~/Documents/Obsidian/Vault/0. Quartz`  
  This makes Quartz available from within my main vault so that I can quickly move notes over and is the same way that I did originally.

Screenshot for reference:  
![[images/Pasted image 20230831183633.png]]

### Publishing and local development
As for publishing and local development I still use the [Shell commands](https://obsidian.md/plugins?search=obsidian-shellcommands) Plugin.

Once installed and added I create 3 commands
#### Quartz Publish 
The following command starts my terminal (`alacritty`) with the publish script.  
This allows me to see if there were any errors during the publishing process.
```bash
alacritty -e ~/Documents/Obsidian/quartz/.helper_scripts/publish.sh
```

#### Quartz Local (Browser)
To start the local dev server and open the browser, I use the following command
  ```bash
  ~/Documents/Obsidian/quartz/.helper_scripts/local.sh browser
  ```
  
#### Quartz Local (Browser)
In case I just need to start the server, I also have this command which just starts the server in the background
  ```bash
  ~/Documents/Obsidian/quartz/.helper_scripts/local.sh
  ```
Screenshot for reference:
![[images/Pasted image 20230831183348.png]]

#### Helper Scripts
I've made my helper scripts public in my repository under https://github.com/husjon/husjon.github.io/tree/v4/.helper_scripts

They need to live under `quartz/.helper_scripts` for everything to work without modifications.

The `publish.sh` script supports pre-publish hooks, in case there are things you want to execute prior to publishing.  
In my case I have a script which updates my read books list under [[Books]]



#### Usage
When the commands are set up and I'm ready to publish, I open the Command Palette, and type `qpub` which is the shorthand for the entire command and hit Enter.  
A few seconds later, it has been pushed to my GitHub repository which will build the page and update my page a few minutes later.
![[images/Pasted image 20230831184738.png]]

Publish in action:
<iframe
  width="560"
  height="315"
  src="https://www.youtube.com/embed/I2tLVYJ9UoQ?si=yNa8_xgCjrHvBmWD"
  title="YouTube video player"
  frameborder="0"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
  allowfullscreen
></iframe>



Alternatively for the local server, I type `qlocb` for also opening the browser, or `qloc` for just the server.
![[images/Pasted image 20230831184610.png]]