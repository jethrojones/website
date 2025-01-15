---
last_modified_at: 
permalink: 
description: 
title: Knowing how to use Transcripts in Podcasts in 2025
image: 
published: "true"
sitemap: "true"
excerpt_separator: <!--more-->
category: 
tags: 
date: 2025-01-15
layout: note
---


{% if page.image %} <img src="{{ page.image }}" alt=""> {% endif %}

I use [Descript](https://get.descript.com/swu3aooczakr) as my podcast editor of choice. 

With Apple Podcasts (and others) now providing transcripts for every podcast episode out there, it's encouraged me to do some research about what is the best way to provide transcripts so they are actually useful to podcast listeners. 

I use Transistor to host my podcasts, and it is a great tool. It allows me to upload transcripts in a variety of formats. 

## Telling Apple Podcasts What to Do
In Apple Podcasts Connect, there is a setting under availability that tells Apple how to handle transcripts, either to "Only display auto-generated transcripts by Apple" or "Display transcripts I provide, or auto-generated transcripts by Apple if one isn't provided". 

I've provided transcripts for Better Teaching, but there are still discrepancies. And I'm not sure what that's about. Here is Apple's [official help file on this topic](https://podcasters.apple.com/support/5316-transcripts-on-apple-podcasts).

Apple recommends using a VTT or SRT file for podcast transcripts, so I will look at both of those here. 

Apple will support speaker labels, headings, timestamps, and more, so I will include those. 



## VTT Transcripts on Podcasts
VTT, according to [Kagi's](https://kagi.com/)[^1] Quick Answer is: 
> **Web Video Text Tracks (WebVTT)**:
> A **VTT file** is a text file format used for storing subtitles or captions for video content. It is part of the HTML5 standard and is designed to enhance the accessibility of web videos, particularly for individuals with hearing impairments or for those watching without sound[1](https://fileinfo.com/extension/vtt)[2](https://nck-anisimov.medium.com/how-to-create-a-vtt-file-in-3-simple-steps-ab86492764b7). VTT files are typically associated with the `<track>` element in HTML5, allowing for timed text display during video playback[3](https://en.wikipedia.org/wiki/WebVTT). The format is similar to SRT files but includes additional capabilities[4](https://verbit.ai/enterprise/vtt-files/).

Here's an example of VTT on podcasts

![VTT example](http://images.weserv.nl/?url={{ site.url }}/assets/betterteaching-vtt.png&w=450&output=jpg&q=65)

It shows up cleanly, which is nice, and this is how it appears when I upload it: 

```
00:00:21.097 --> 00:00:24.817
A quick reminder, we will be
sharing only stuff that works.

00:00:24.837 --> 00:00:27.987
No cliches, no buzzwords.

00:00:28.292 --> 00:00:34.159
So my guest today is Bill Davidson, and
this summer Bill Davidson is entering

00:00:34.159 --> 00:00:36.549
his 24th year working in education.

00:00:37.189 --> 00:00:42.709
He's taught in Philadelphia, Los Angeles,
Southern Sudan, and Monterey, California.

00:00:42.709 --> 00:00:42.759
Yeah.

00:00:43.239 --> 00:00:46.506
For the past 12 years, he's worked
independently as as an elementary
```

You can see that it includes timestamps. 


## SRT Transcripts for Podcasts
Again, from Kagi's quick answers: 
> An **SRT** file, which stands for **SubRip Subtitle**, is a widely used file format for adding subtitles or captions to video content. It originated from the SubRip software, which extracts subtitles from video files and produces plain text files that include both the subtitle text and timing information. 

Different from VTT, the SRT file will add a numeric identifier, as shown here: 

```
10
00:00:38,958 --> 00:00:41,508
A quick reminder, no
cliches, no buzzwords.

11
00:00:41,843 --> 00:00:43,213
Only stuff that works.

12
00:00:44,305 --> 00:00:49,995
I am very excited about today's episode,
and we are taping this episode on January

13
00:00:50,035 --> 00:00:54,725
3rd, and I think it's appropriate that
this is a New Year's episode because so

14
00:00:54,725 --> 00:00:59,235
many people have New Year's resolutions
and goals, and I'm sure many of the

```

# Should I use VTT or SRT for podcast transcripts? 
While either will work, use VTT because it is part of the HTML5 standard. 

VTT and SRT for all intents and purposes are the same thing, for most people. Because VTT is an accepted and advanced feature in the HTML5 standard, it will be more accessible for web-based usage, like podcast transcripts. You can also add styling indicators to the VTT file, if desired. 

When a transcription reading service (YouTube, Apple Podcasts, or any other tool) takes the transcript from either of these sources, they take out the timestamps and only display the text at those time segments. 

## Exporting Transcripts on Descript so they show up in Apple Podcasts
These are the settings I use to make sure transcripts show up how I want them in Apple Podcast: 

![descript vtt](http://images.weserv.nl/?url={{ site.url }}/assets/descript vtt export.png&w=450&output=jpg&q=85)

I chose Publish > Export then select Subtitles. 

Then choose the format, VTT or SRT. 

Enable Show Speakers and I leave max characters per line at 42, and max lines per card at 2. 

Then click, "Export" and it downloads a .vtt file which I then upload to Transistor for that episode. 
# Text Files as Transcripts
When text files are exported from Descript, and uploaded to our host, they don't propagate to Apple Podcasts and they are considered "not submitted". This episode on Better Teaching used a text file to upload the transcript:

![Text Transcript](http://images.weserv.nl/?url={{ site.url }}/assets/bt-txt.png&w=450&output=jpg&q=65)

Apple considered this not submitted and auto-generated the transcript. 


[^1]: Kagi is, by the way, the best search out there right now. Completely user-funded, no ads, no tracking. And that's not even the best part. The results are significantly better for every search I've run over Google's or DuckDuckGo's. 