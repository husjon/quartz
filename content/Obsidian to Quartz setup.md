---
title: Obsidian to Quartz setup
tags:
  - obsidian
  - quartz
  - quartz-v4
created: 2023-08-27T21:41:34+02:00
updated: 2024-11-26T00:54:15+01:00
publish: true
---
## Introduction
I originally wrote about my [[Obsidian to Quartz setup v3]] at the end of 2022.  
Now since Quartz v4 is out, this is my current setup (originally written August 2023, updated November 2024).

First of, [Jacky Zhao](https://github.com/jackyzha0) has done amazing work with reducing dependencies of the Quartz project and now uses `npx` to build, publish and do local development instead of previously using a `go` and in particular the `hugo-obsidian` package.  
This also reduced the publishing script I created for the previous setup ([[Obsidian to Quartz setup v3#Publishing my notes.|Publishing my notes]]).


## Upgrading
If you're upgrading I would recommend reading the https://quartz.jzhao.xyz/migrating-from-Quartz-3 guide from the documentation.  
If you're new to Quartz, check out Getting Started section on https://quartz.jzhao.xyz/



## The Setup
Now, my setup is quite similar my [[Obsidian to Quartz setup v3#Preparing the Obsidian Vault|original write-up]], however some things have changed.

### Folder Structure
My folder structure changes are minor, now everything is moved into `~/Documents/Obsidian` so that everything is grouped together.
* **Main Vault** lives under `~/Documents/Obsidian/Vault`
* **Quartz** lives under `~/Documents/Obsidian/quartz`
* A **Quartz** folder within my **Vault**  
  This folder gets copied over during [[#Quartz Publish|Publishing]] and symlinked during [[#Quartz Local (Browser)|Local Development]].  
  `~/Documents/Obsidian/Vault/000-Quartz -> ~/Documents/Obsidian/quartz/content`  
  This allows me to do all the writing for this site in my main vault without changing over to another vault.


### Publishing and local development
As for publishing and local development I still use the [Shell commands](https://obsidian.md/plugins?search=obsidian-shellcommands) Plugin.

I have 3 commands for:
* [[#Quartz Publish|Publishing]]
* [[#Quartz Local (Browser)|Local Development]]
* [[#Quartz Local|Local Development (server only)]]

Screenshot for reference:
![[images/quartz-obsidian_shell_commands_overview.png]]

#### Quartz Publish 
The following command starts my terminal (`kitty`) with the publish script.  
This allows me to see if there were any errors during the publishing process and verify what is being published.
```bash
kitty ~/Documents/Obsidian/quartz/.helper_scripts/publish.sh \
  --obsidian-vault {{vault_path}} \
  --quartz-vault {{vault_path}}/000-Quartz
```
More about how it runs in [[#Usage]]

#### Quartz Local (Browser)
To start the local development server and open the browser, I use the following command
```bash
~/Documents/Obsidian/quartz/.helper_scripts/local.sh \
  --quartz-vault {{vault_path}}/000-Quartz \
  --browser
```  
(the server runs for at most 1 hour)

#### Quartz Local
In case I just need to (re-)start the server, I also have this command which just starts the server in the background
```bash
~/Documents/Obsidian/quartz/.helper_scripts/local.sh \
  --quartz-vault {{vault_path}}/000-Quartz
```
(the server runs for at most 1 hour)



#### Helper Scripts
My helper scripts are all available in my repository under the [.helper_scripts](https://github.com/husjon/husjon.github.io/tree/v4/.helper_scripts) folder

They need to live under `quartz/.helper_scripts` for everything to work without modifications.

The `publish.sh` script supports pre-publish hooks, in case there are things you want to execute prior to publishing.  
In my case I have a script which updates my read books list under [[Books]]
It also sources a file named `quartz_publish.env` under the users home directory which can contain API keys etc.


## Usage
When the commands are set up and I'm ready to publish, I open the Command Palette, and type `qpub` which is the shorthand for the entire command and hit Enter.  
1. It starts up a terminal showing the progress of each pre-publish hook that's run.
2. It shows a `git diff` of the changes
3. Asks me to press **Enter** to confirm the publish.
A few seconds later, it has been pushed to my GitHub repository which will build the page and update my page a few minutes later.
![[images/quartz_obsidian_command_palette-publish.png]]

Publish in action:
<iframe
  width="560"
  height="315"
  src="https://www.youtube.com/embed/6le11WJymng"
  title="YouTube video player"
  frameborder="0"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
  allowfullscreen
></iframe><br/>
(video have not been update to reflect theme change, but process is the same)



Alternatively for the local server, I type `qlocb` for also opening the browser, or `qloc` for just the server.
![[images/quartz_obsidian_command_palette-local.png]]
