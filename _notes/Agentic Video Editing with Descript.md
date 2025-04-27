---
last_modified_at: 
permalink: descriptagentic
description: Discover how Descript's Agentic Editing transforms video creation by automating complex tasks, enhancing creativity, and simplifying the editing process. Dive into the future of effortless video production with this innovative tool.
title: Exploring Descript's Agentic Editing
image: 
published: "true"
sitemap: "true"
excerpt_separator: <!--more-->
category: 
tags: 
date: 2025-04-26
layout: note
---


{% if page.image %} <img src="{{ page.image }}" alt=""> {% endif %}

## Why Descript's Agentic Editing is Amazing
I can see the vision for this tool, and it is remarkable. 

Here's Andrew Mason explaining what it is all about if you've not yet heard about this: 

Here's the short version. Agentic editing using AI to do the busy work of editing so you can sit in the director's chair and tell the AI how to edit your video or audio. 

Automating the busywork of podcast editing is awesome. It feels great to be in the "director's chair" instead of the editing chair. 

This new Agentic Editing on [Descript](https://get.descript.com/swu3aooczakr) was announced this week, and I'm stoked I got to dig into already! 

Keep in mind, I'm playing with this on the first week out! It's still very beta and I get that. 

Let me tell you what it rocks at, from the very beginning: 
- It did multicam for me just by me telling it to
- It got titles, screens and everything set up correctly on the first try. 
- It used a layout pack that Descript has automatically loaded, and it looks great.
- It made transitions that look nice and pretty. 
- It *knows* itself. 

There were a few times where the agent didn't do what I asked it to, and it knew it didn't, and it gave me clear steps of what to do next to do it manually. 

It even pulled my guest's name and title from the transcript and added it to her introduction screen.

![shenita_title.png](http://images.weserv.nl/?url={{ site.url }}/assets/shenita_title.png&w=450&output=jpg&q=100)

I learned some things that I didn't know before, which is always good. 

## Biggest Takeaway for this First Version: 
Know what you want to do before you start because it's not going to be great at changing what it already started. 

## Where Descript's Agent is Still Growing: 
It's not yet great at additional directions. 

Multiple times I got a "There was a technical issue. Would you like me to give you step-by-step directions to do that manually?" as I mentioned above, but the fact that it knew it had failed and told me how to do it myself was really great. 

Also, there were a couple issues of hallucination, but in this case, it didn't make something up, it said that things were done that weren't. 

There are a few things it doesn't do, yet, and I told it I thought it should. It responded with: 

> Currently, my direct editing capabilities are limited to text, scenes, layouts, and some visual properties, but not to advanced video color correction (like exposure, contrast, or temperature) on individual video layers. That’s why I provided the step-by-step instructions for you to apply those adjustments in Descript’s interface.

I was going to paste the whole conversation below, but it looks like there's some info in there that probably shouldn't be exposed. Also, it got unreasonably long! 13,000 words! So, I'll just paste the first little bit below: 

```


## User: OK, first, add markers to this for each question that speaker Jethro asks. Then add automatic multicam so the speaker is the focus. You can add smooth transition, and titles with the markers you created that will stay on the screen for a few seconds
Message id: `b70dec92-9c5e-4d24-9b1b-41f6a90b01ba`

Internal context
{"sceneId":"da4c574d-8881-4830-a46a-8994eae4881e","textSelection":{"loc":2,"delta":0},"playheadTime":0}


## Assistant (9.0s)
Message id: `d5b326d0-8aef-48bd-973c-bc593d664e51`
> Here’s my plan to accomplish your request:
> 
> > 1. Identify all questions asked by the speaker Jethro in the script.
> > 2. Add chapter markers at each of Jethro’s questions.
> > 3. Apply automatic multicam so the active speaker is the focus throughout.
> > 4. Add smooth transitions between scenes.
> > 5. Add titles at each marker, using the marker text, and have them display for a few seconds.
> 
> Let me start by:
> - Locating all of Jethro’s questions and adding markers.
> - Then I’ll proceed with multicam, transitions, and titles.
> 
> Let’s get started by finding all of Jethro’s questions and adding markers.

### Tool Calls

Tool Call #1: `query_script_and_scenes`
id: `call_rjxwJMoP49sY4omMf63by6LY`
```json
{
  "include_timestamps": false
}
```

There are a bunch of these Tool Calls all throughout. If it doesn't know what to do, it searches help and gives an answer based on that. 

It also provides links to help pages to make it easier to do what I need to. 

Now, this podcast isn't completely edited, and certainly it took me longer to write this up than it did to make the edits here. 

## Questions Remain!

- Does the length of the video matter in how it makes the edits and content? i.e. token limits?
- What's the plan for allowing more advanced features that don't work just yet? 
- What are the limitations currently? 

## Overall
I've got to say, this is incredible. With complex software, sometimes you just don't know where the control is for a specific thing you are trying to do. This is a challenge because there is the mechanistic skill of learning the tool itself, where the buttons and functions are, and the [organic skill](https://drjethro.com/assign1) knowing when to make certain decisions. I want to spend my time on the organic skills, not the mechanistic skills. 

That is what Descript's Agentic editing will allow. I see the vision of the future and I can't wait to continue testing and playing with this. 

Here's the video I edited briefly, in it's unfinished state. 