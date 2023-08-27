---
title: Obsidian to Quartz setup
created: 2022-11-25T23:03:07+01:00
updated: 2023-08-27T23:39:53+02:00
tags:
  - obsidian
  - quartz
  - quartz-v3
---
## Introduction
The other day I decided that I'd wanted to start publishing some of my ideas.  
Finding that [Obsidian Publish](https://obsidian.md/pricing) was a bit too pricey for the occasional publish I decided to look at alternatives.

After trying a few different approaches I finally found [Quartz][quartz_link] and started playing around with it.

After some finagling trying to figure out how I'd like to structure my Obsidian Vault without much change, this is what I ended up with.



## Setting up the repository
First of I created a repository based on the [Quartz][quartz_git_link] template repository.  
  This is a matter of just clicking **Use this template** > **Create a new repository**

Repository name was set to [husjon.github.io](https://husjon.github.io).  
This allows me to utilise to the base URL of GitHub Pages.  
I set my repository as **Private**, you may choose **Public** if you like.

Next I went to my newly set up repository's **Settings** > **Pages**  
I then set the Branch to `master` and folder to `/ (root)` and hit **Save**.



## Setting up Quartz
Next I cloned my newly created repository to my computer.  
I decided to place it next to my vault, which makes it easier to reference when setting up the bash script for publishing my notes.

After looking through the documentation and the content of the repository, I updated the configuration to suit my needs, f.ex:
* Enable the Global Graph on the homepage (I might change this when more pages are added).
* Disabled GitHub Edit (Didn't need it since I'm using Obsidian to write these posts)

I then clearing out the `content/` folder, except for the `_index.md` file, made a commit and pushed the changes.

I now had a brand new Quartz site ready to be populated.



## Preparing the Obsidian Vault
After some thinking I as mentioned placed the Quartz repository next to my Obsidian Vault.

The directory tree would be very similar to the following:
```
~/Documents
├── Obsidian_Vault
└── quartz
```

With the folders set up, I then made a symlink from the **Quartz** `content` folder into my Obsidian Vault.
```bash
# Naming it 0.Quartz allows it to be at the top of the vault tree.
ln -rs ~/Documents/quartz/content ~/Documents/Obsidian_Vault/0.Quartz
```
This allows me to have easy access to the files which are going to be published to my Quartz site from within Obsidian.



## Publishing my notes.
With everything set up, I was now able to edit my files from within Obsidian.  
The tedium now was that I now had to have a terminal open, commit my files and then push it.

I started putting together a quick helper script which I added to a hidden folder within my Obsidian Vault named `.helper_scripts`.
```
~/Documents/Obsidian_Vault
├── .helper_scripts
│  └── publish.sh
├── 0.Quartz -> ../quartz/content
├── ...
├── ...
└── Other Vault Files
```


The script I came up with was as follows (codeblock is rendered wrongly but you can find a gist below):
```bash
#!/bin/bash

PATH=~/go/bin:$PATH
BASE_DIR="$(realpath "$(dirname "$0")")"
OBSIDIAN_NOTES="${BASE_DIR}/.."
QUARTZ_FOLDER="${OBSIDIAN_NOTES}/../quartz"
QUARTZ_CONTENT="${QUARTZ_FOLDER}/content"

GIT_REF=34bb5aa

type hugo-obsidian || \
    go install github.com/jackyzha0/hugo-obsidian@"${GIT_REF}"

cd "${QUARTZ_FOLDER}"
rm -rf public resources linkmap > /dev/null
rm assets/indices/*

hugo-obsidian \
    -input="./content" \
    -output="./assets/indices" \
    -index \
    -root="."

cd "${QUARTZ_CONTENT}"

if git diff --exit-code; then
    notify-send "Quartz" "No changes"
    exit
fi

git add ./ && \
    git commit -m "Updated: $(date +%Y.%m.%d-%H%M)" && \
    git push && \
    notify-send "Quartz" "Pushed changes"
```
Gist: [gist.github.com/husjon/a25d9f62645122eef7bf4eeaed1ba62c](https://gist.github.com/husjon/a25d9f62645122eef7bf4eeaed1ba62c)

**Note**:
* I already have [golang](https://go.dev/) installed.
* I use `notify-send` to interact my notification daemon (`dunst`).

The script does the following:
* Fetches the `hugo-obsidian` parser, if we do not already have it.
* Navigates to the quartz folder and clean out old files.
* Runs `hugo-obsidian` to populate the linktree (for the interactive graph)
* Checks if there are changes and if so, makes a commit with the current time and date.
* Finally pushes the changes to the repository.

After a couple of minutes the site is updated with my newly published notes.

This all worked fine and I now only had to run a single script to publish my notes,  
but I still needed to have a terminal open and I'd like to publish from within Obsidian.

After some thinking and looking through the Obsidian Plugins list I found and installed the plugin [obsidian-shellcommands](https://obsidian.md/plugins?search=obsidian-shellcommands)



## Shell Commands Plugin
Using the **Shell Commands** plugin, made this a breeze.

With the plugin installed and enabled I started looking at the settings and found it rather easy to come up with something.

### Enabling Publish from the command palette
* First I added a **New shell command** and added the path to the publish script.  
  `~/Documents/Obsidian_Vault/.helper_scripts/publish.sh`
* Clicking on the **cogwheel / gear** I could add an **Alias**  
  `Publish Quartz`
* I also wanted a prompt that I needed to confirm prior to publishing.
  * Looking at **Preactions**, I could **Create a a new Prompt**
  * I gave it the title `Publish notes?`

I can now open the command palette (`Ctrl+Shift+P` in my case) and type `Publish`.  
I then see `Shell commands: Execute: Publish Quartz`.  
When I then hit **Enter**, I'm asked if I really want to publish my notes.  
After confirming I get a notification within a few of seconds that my notes have been pushed.  
Within the next minute or two GitHub actions have made my notes available on my Quartz site.



# Final thoughts
I've never been much of a writer in the public sense, however having a tool for writing like [Obsidian][obsidian_link] and a static site generator like [GitHub Pages][github_pages_link] / [Quartz][quartz_link] to present them lowers the barrier to entry.

If you've come so far and read through this writing, I'd like to thank you and I hope it might inspire you to either try it out or improve upon it to suit your needs.



[obsidian_link]: <https://obsidian.md/>
[github_pages_link]: <https://pages.github.com/>
[quartz_link]: <https://quartz.jzhao.xyz>
[quartz_git_link]: <https://github.com/jackyzha0/quartz>
