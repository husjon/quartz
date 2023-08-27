---
title: Obsidian to Quartz setup
tags:
  - obsidian
  - quartz
  - quartz-v4
created: 2023-08-27T21:41:34+02:00
updated: 2023-08-27T22:01:32+02:00
draft: true
---

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