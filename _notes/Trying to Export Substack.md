---
last_modified_at: 
permalink: 
description: 
title: 
image: 
published: "true"
sitemap: "true"
excerpt_separator: <!--more-->
category: 
tags: 
creation date: 2024-11-21 15:04
layout:
---


{% if page.image %} <img src="{{ page.image }}" alt=""> {% endif %}

Another reason why you [[Don't call it a Substack. - Anil Dash]]. 

I'm trying to export my Substack posts to add to this site. 

Well, it's not easy. 

Substack exports them, without dates, as 

```
138036639.be-strong-so-you-can-be-humble.html
```

Then, inside the HTML file, it is one single line, of 17,000 characters. Not helpful. 

I've tried using a couple services to get it out of Substack, but because I'm not [famous enough](https://rsilt.substack.com/p/how-i-got-my-substack-to-be-google) I don't have a sitemap so [none](https://www.substacktools.com/downloader) of [the tools](https://github.com/timf34/Substack2Markdown) I used work. 

There's also not an [updated Jekyll importer](https://import.jekyllrb.com) for Substack, so I don't know how I'm going to make this work. 

Thankfully, I only have 65 files on there, so if I just manually rename them to 

```
2023-10-17-be-strong-so-you-can-be-humble.html
```

That should output them to [this page](https://jethro.site/2023/10/17/be-strong-so-you-can-be-humble/). Should be close enough. 

The images are still hosted on substack, so I'll need to figure out how to manually bring those over also. 
