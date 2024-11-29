---
last_modified_at: 
permalink: 
description: 
title: Trying to Export Substack
image: 
published: 2024-11-21
sitemap: "true"
excerpt_separator: <!--more-->
category: 
tags: 
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

*Update: November 29, 2024*

Regarding that 17,000 character single line of code. I tried something else (TextSoap) to make it work, and it didn't. So I used [ChatGPT](https://chatgpt.com/share/6749ced3-e130-800f-9d76-c07d539cc1d0) to get it reorganized. It was so much that it had to stop in the middle and I had to continue generating. But at least it is much cleaner and more readable now. 

However, pasted into my text editor, that is still 121 lines of code for the entire file. 

But still, it's terribly complex and so much there. When I write in Markdown, it's actually readable and understandable by a normal human. That's why I love it. Writing in Simple HTML is close, but it still doesn't hold a candle.

If I take out what is unnecessary and write it in markdown, it not only looks prettier and is more readable, but it also is only 29 lines total. Please note: in markdown, each paragraph counts as one line, and there are six paragraphs in [this particular piece of writing](https://jethro.site/2023/10/09/the-value-of-spiritual-learning/). 

So this process of moving off of Substack is going to be quite time consuming and will require many steps to get what I want to happen. 

This is the real problem with lock-in. And it's another way [[people ruin the internet]].

