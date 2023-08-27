---
title: "Amazon Kindle Download Helper"
tags:
  - programming
  - javascript
  - tampermonkey
created: 2022-11-27T19:35:16+01:00
updated: 2023-08-27T22:01:31+02:00
---

After having acquired a few books for my Kindle from Amazon, I've found that backing these up is extremely tedious.  
In case you've not experienced it, here are the steps:
1. Go to [Manage Your Content and Devices][kindle_manage_content]
2. Click **More actions**
3. Click **Download & transfer via USB**
4. Select the device to download for (for [DRM][wiki_drm] reasons)
5. Click **Download**
6. Repeat step 2 - 5 for each book

This as you might understand, gets really annoying really quickly, especially when buying a couple of books on sale.

So after some thinking I thought I might try to give a shot at using JavaScript and [TamperMonkey][TamperMonkey] which injects userscripts on any page you want to simplify this process.  
Tampermonkey allows you to do quite a few cool things like changing colors, adding/removing features and a whole lot more.

It's been a while since I've done any work with Javascript and jQuery, so revisiting it was quite refreshing.

After spending some time finding which elements I needed for selectors etc, I came up with a simple solution which re-uses the existing checkboxes and adds a button to download the selected books.
![[../images/amazon_download_button.png]]

With this helper, we can now use the existing checkboxes or **Select All**, then the newly added **Download Selected** button.  
The script then iterates over each book on the current page, then starts the download process for each.

Here's a video showing it in action:
<iframe width="560" height="315" src="https://www.youtube.com/embed/3s_imgnmzJQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


If this is something that you'd like to use yourself, you can find it in my [Tampermonkey repository][tampermonkey_repository]

[kindle_manage_content]: https://www.amazon.com/hz/mycd/digital-console/contentlist/allcontent/dateDsc
[wiki_drm]: https://en.wikipedia.org/wiki/Digital_rights_management
[tampermonkey]: https://www.tampermonkey.net/
[tampermonkey_repository]: https://github.com/husjon/tampermonkey