---
last_modified_at: 2025-01-09
title: Add Fathom Analytics to your Obsidian Publish site
source: https://www.micahwalter.com/2024/01/add-fathom-analytics-to-your-obsidian-publish-site/
author:
  - Micah Walter
date: 2025-01-09
description: The right way to get Fathom Analytics to work with Obsidian's Publish plugin.
tags:
  - clippings
image: 
category: colophon
published: "true"
---
In trying to figure out how to add analytics to my [drjethro](https://drjethro.com) [^1] site, I had to do a little digging. I was stoked to find this little page: 
> Today I figured out how to embed the tracking code for [Fathom Analytics](https://usefathom.com/) into an [Obsidian Publish](https://obsidian.md/publish) website. It’s easy.

{% if page.source and page.author %}
  <p>via <a href="{{ page.source }}">{{ page.author }}</a></p>
{% endif %}

Well, turns out it wasn't that easy. 

[Obsidian](https://help.obsidian.md/Obsidian+Publish/Analytics) lists this as the code you need to put into a publish.js file at the root of your obsidian folder: 

```javascript
var fathom = analyticsScript.createElement('script');
analyticsScript.defer = true;
analyticsScript.setAttribute('data-site', 'yourdomain.com');
analyticsScript.src = 'https://cdn.usefathom.com/script.js';
document.head.appendChild(analyticsScript);
```
That didn't work. 

Micah shared this code: 

```javascript
var fathomSnippet = document.createElement('script');
fathomSnippet.defer = true;
fathomSnippet.setAttribute('data-site', '<your-site-code>');
fathomSnippet.src = 'https://cdn.usefathom.com/script.js';
document.head.appendChild(fathomSnippet);
```

But that didn't work for me. 

I reached out to support at Fathom and Awesome Ash shared this update: 

```javascript
var fathomScript = document.createElement('script');
fathomScript.defer = true;
fathomScript.setAttribute('data-site', 'SITEID');
fathomScript.src = 'https://cdn.usefathom.com/script.js';
document.head.appendChild(fathomScript);
```

I entered that with my site code and it registered immediately. 

I also use ChatGPT to help me code, since I'm new at this. And this is the code ChatGPT gave me: 

```javascript
var analyticsScript = document.createElement('script');
analyticsScript.defer = true;
analyticsScript.setAttribute('data-site', 'YOUR_SITE_ID_HERE');
analyticsScript.src = 'https://cdn.usefathom.com/script.js';
document.head.appendChild(analyticsScript);
```

Which looks identical to what Ash sent over, except ChatGPT used `analyticsScript` and she used `fathomScript`. 

Ash said there was a small error in the Obsidian code:

> It's referring to 'analyticsScript', which isn't ever defined, so it's just returning 'null' and preventing the code in the publish.js file from running.

It also lists 'yourdomain.com' which I don't think is right either. I think it has to be the SITEID, which is what I used, and what Ash recommended in her email to me. And now it's working well on my [drjethro.com](https://drjethro.com) site. 

You see, this is a good example of where [[AI MOC|AI]] can sometimes be beneficial. I could have used ChatGPT to get that answer, but Ash had more context working at Fathom, and could provide clearer help and direction, so I could understand. ChatGPT's answer was: 

> The issue with your JavaScript snippet is that you are creating the script element incorrectly. You should be calling document.createElement('script') directly, not analyticsScript.createElement('script').

You see, I don't have the [[Ethan Mollick on Knowing When to Use AI|expertise]] to understand what the AI was saying there, but Ash explained it in a way that made sense. 

[^1]: I can't believe I scored that domain name!