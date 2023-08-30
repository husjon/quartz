---
title: Obsidian to Quartz setup
tags:
  - obsidian
  - quartz
  - quartz-v4
created: 2023-08-27T21:41:34+02:00
updated: 2023-08-30T18:07:59+02:00
draft: true
---

## Introduction
This is a followup from my [[Obsidian to Quartz setup v3]] after Quartz updated to version 4.

**Note:** Since Quartz v4 release just a week ago, my setup is still under development and this post will change over time.


## Upgrading
Upgrading to version 4 was pretty straight forward.
In your quartz repository: 
* `git fetch`
* `git checkout v4`
* `git pull upstream v4`
* `npm i`
* `npx quartz create`

For more information, the full step by step guide can be found in the documentation (https://quartz.jzhao.xyz/migrating-from-Quartz-3)


## Publishing
I still use the Obsidian plugin [Shell commands](https://obsidian.md/plugins?search=obsidian-shellcommands) for quickly spinning up the local development server and publishing my notes.

[Jacky Zhao](https://github.com/jackyzha0) has done amazing work with reducing dependencies of the Quartz project and now uses `npx` to build, publish and do local development instead of previously using a `go` and in particular the `hugo-obsidian` package.

This also reduced the publishing script I created for the previous setup ([[Obsidian to Quartz setup v3#Publishing my notes.|Publishing my notes]]).
```bash
#!/bin/bash

export BASE_DIR="$(dirname "$(realpath "$0")")"
export QUARTZ_FOLDER="$(realpath ${BASE_DIR}/../quartz)"

cd "${QUARTZ_FOLDER}" || exit 1

npx quartz sync
```
As for spinning up the local development server, we can run `npx quartz build --serve`. (See [[Obsidian to Quartz setup v3#Shell Commands Plugin]])
In a few seconds, the server is available at `http://localhost:8080`