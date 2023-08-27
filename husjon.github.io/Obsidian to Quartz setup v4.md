---
title: Obsidian to Quartz setup
tags:
  - obsidian
  - quartz
  - quartz-v4
created: 2023-08-27T21:41:34+02:00
updated: 2023-08-27T23:55:15+02:00
draft: true
---

## Introduction
This is a followup from [[Obsidian to Quartz setup]] after Quartz updated to version 4.

[Jacky Zhao](https://github.com/jackyzha0) has done amazing work with reducing dependencies of the Quartz project and now uses `npx` to build, publish and do local development.




```bash
#!/bin/bash

export BASE_DIR="$(dirname "$(realpath "$0")")"
export QUARTZ_FOLDER="$(realpath ${BASE_DIR}/../quartz)"
export QUARTZ_CONTENT="${QUARTZ_FOLDER}/content"


cd "${BASE_DIR}" || exit 1
for f in ./publish.d/*; do
    ${f}
done

cd "${QUARTZ_FOLDER}" || exit 1

npx quartz sync
read
```