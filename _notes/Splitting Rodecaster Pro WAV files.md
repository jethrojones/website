---
last_modified_at:
permalink:
description: Learn how to efficiently split Rodecaster Pro WAV files into separate tracks for guests and hosts using a custom Shortcut. This guide provides a step-by-step solution to manage large poly-WAV files, making podcast editing easier with Descript. Download the script and streamline your audio editing process.
title: Splitting Rodecaster Pro WAV files
image:
published: "true"
sitemap: "true"
excerpt_separator: <!--more-->
category:
tags:
date: 2025-09-19
layout: note
---

Use [this Shortcut](https://www.icloud.com/shortcuts/5d0f1214733a46ba856a210155d929eb) to auto-split your Rodecaster Pro WAV files into one WAV file for the guest and host. 
{% if page.image %} <img src="{{ page.image }}" alt=""> {% endif %}

I record a [lot of podcasts](https://bepodcastnetwork.com). Sometimes, I get to do them live in person, and that's a lot of fun. 

At least it is until it is time to edit them. I use [Descript](https://get.descript.com/swu3aooczakr) to edit all my podcasts, and when Rodecaster Pro records multichannel to the SD card, it records it as one WAV file, with multiple tracks inside that file. 

When I upload that single file to Descript, Descript reads it as a single WAV file, not a poly-WAV file. 

There are a couple problems here: 

First, the poly-wav file is HUGE! 14 tracks are silent, but there's still data there, so the filesize is enormous. a ten minute interview is 1.4 GB! A ten minute interview on a single-track WAV file is about 100 megabytes. 

Second, Descript doesn't allow me to create a sequence from that poly-wav file and so I can't edit out the breathing from one person, for example, or deal with mic bleed. 

What I used to do is open those in another app that would split the tracks, but that is tedious, and when I do 15 interviews in one day, it's quite tedious. 

I know there are ways to script your computer to save you time and energy, but I don't know how to write scripts. 

So, I turned to trusty ChatGPT to do this for me. I asked it to create a script that I could include in the Shortcuts app to have it run anytime I put something in that folder. 

You can download this shortcut yourself and try it out by clicking this [link](https://www.icloud.com/shortcuts/5d0f1214733a46ba856a210155d929eb). 

Let me include the code here as well, with comments included by ChatGPT, because I have directed ChatGPT to include verbose comments when it writes code for me so I can understand what is happening. 

```
#!/bin/bash
set -euo pipefail

# Make Homebrew ffmpeg visible to Shortcuts
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

FFMPEG="${FFMPEG_PATH:-$(command -v ffmpeg)}"
FFPROBE="${FFPROBE_PATH:-$(command -v ffprobe)}"
LOG="/tmp/rode_split.log"

# ---- CONFIG ----
# RØDECaster Pro 1 (fw 2.1.2) — your confirmed mapping:
#   Mic 1 -> channel index 2 (zero-based)
#   Mic 2 -> channel index 3 (zero-based)
MIC1_CH_INDEX="${MIC1_CH_INDEX:-2}"
MIC2_CH_INDEX="${MIC2_CH_INDEX:-3}"
OUTDIR_NAME="${OUTDIR_NAME:-split}"   # shared output folder name (per source directory)

if [[ -z "${FFMPEG:-}" || -z "${FFPROBE:-}" ]]; then
  echo "ffmpeg/ffprobe not found on PATH" >> "$LOG"
  exit 1
fi

for f in "$@"; do
  [[ -f "$f" ]] || { echo "Skip (not a file): $f" >> "$LOG"; continue; }

  # Case-insensitive .wav check (Bash 3.2 compatible)
  ext="${f##*.}"
  shopt -s nocasematch
  if [[ ! "$ext" =~ ^wav$ ]]; then
    shopt -u nocasematch
    echo "Skip non-WAV: $f" >> "$LOG"
    continue
  fi
  shopt -u nocasematch

  dir="$(cd "$(dirname "$f")" && pwd)"
  base="$(basename "$f")"
  name="${base%.*}"

  outdir="$dir/$OUTDIR_NAME"
  mkdir -p "$outdir"

  # Probe channel count
  channels="$("$FFPROBE" -v error -select_streams a:0 -show_entries stream=channels \
             -of default=nw=1:nk=1 "$f" | tr -d '[:space:]' || true)"
  echo "[$(date)] $base → channels=$channels" >> "$LOG"

  if [[ ! "$channels" =~ ^[0-9]+$ ]]; then
    echo "No channel info from ffprobe, skipping: $f" >> "$LOG"
    continue
  fi
  if (( MIC1_CH_INDEX >= channels || MIC2_CH_INDEX >= channels )); then
    echo "Not enough channels ($channels) for indexes $MIC1_CH_INDEX/$MIC2_CH_INDEX" >> "$LOG"
    continue
  fi

  # Output paths include source basename to avoid collisions across files
  mic1_out="$outdir/${name}_mic1.wav"
  mic2_out="$outdir/${name}_mic2.wav"

  # MIC 1
  "$FFMPEG" -hide_banner -loglevel error -y -i "$f" \
    -filter_complex "[0:a]pan=mono|c0=c${MIC1_CH_INDEX}[m1]" \
    -map "[m1]" -c:a pcm_s24le "$mic1_out"

  # MIC 2
  "$FFMPEG" -hide_banner -loglevel error -y -i "$f" \
    -filter_complex "[0:a]pan=mono|c0=c${MIC2_CH_INDEX}[m2]" \
    -map "[m2]" -c:a pcm_s24le "$mic2_out"

  echo "Wrote: $mic1_out, $mic2_out" >> "$LOG"
done

echo "OK"
```


If you need to add more/different sources from your original file, you can easily do that by updating which fields you want to split out. I know I only use mic channels 1 and 2, so I don't need anything else there. 

My resulting folder of split WAV files came in at 2.46 GB instead of 34GB, and my files are now split appropriately for importing into Descript in a much easier and appropriate way. 

I then asked ChatGPT to make a version that I could share with others if they have different needs. You can get [that here](https://gist.github.com/jethrojones/f4f6f930e3bb62971b607dcafb4b6080).