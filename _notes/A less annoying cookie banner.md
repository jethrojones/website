---
last_modified_at: 2025-01-08
title: "A less annoying cookie banner"
source: "https://www.laynedillard.com/"
author:
  - "Dr. Layne H. Dillard"
published: true
date: 2025-01-08
description: “No cookie banners are annoying. This one actually shows you what you’re missing out on.”
tags:
  - "clippings"
image:
category:
permalink: /lessannoyingcookie
---
Cookie banners are a way [[people ruin the internet]]. 

I was interviewing someone for my podcast, and I saw that her web site had a banner at the top saying it couldn’t show me information because I didn’t allow a cookie. 

![facebookconsentbanner](http://images.weserv.nl/?url={{ site.url }}/assets/facebookconsentbanner.png&w=450&output=jpg&q=65)


> Content from Facebook can't be displayed due to your current cookie settings. To show this content, please click "Consent & Show" to confirm that necessary data will be transferred to Facebook to enable this service. Further information can be found in our [Privacy Policy](https://www.laynedillard.com/privacy-policy/). Changed your mind? You can revoke your consent at any time via your [cookie settings](https://www.laynedillard.com/cookie-settings/).

What was nice about this is that it showed me the content, the space it would take up, and instead of an annoying banner it was just part of the page. 

And, since I don’t want or need Facebook to be tracking me here, I could easily dismiss it. 

{% if page.source and page.author %}
  <p>via <a href="{{ page.source }}">{{ page.author }}</a></p>
{% endif %}