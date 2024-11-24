---
last_modified_at: 
permalink: 
description: How to move your podcast from BlogTalkRadio to Transistor.
title: 
image: 
published: "true"
sitemap: "true"
excerpt_separator: <!--more-->
category: 
tags: 
creation date: 2024-11-22 10:51
layout: note
---

{% if page.image %} <img src="{{ page.image }}" alt=""> {% endif %}
The podcast host [BlogTalkRadio is shutting down effective January 31, 2025](https://podnews.net/article/blogtalkradio-customer-email). 

One of my colleagues has a podcast on that site, so he asked me to help him save his podcasts from being lost to the world. 

When you move podcast hosts, it's not difficult, but some hosting companies make it difficult, which is really a shame. 

It should be easy to move. 

I'll document and update things here. 

There are a few things that are essential to move to another podcast host. 

1. Bring in old episodes
2. Set up a redirect on the old host site. 

Honestly, that's it. It doesn't take much. 

With just a few months of planning time, before the shut down in January, you need to move quickly. 

Transistor makes it really easy to bring a podcast over. They have a great interface that allows you use either the Apple Podcasts listing, just by searching for the name, or you can plug in the RSS feed. 

For this particular show, Transistor even warned me something wasn't right. 

![300 limit]({{ site.url }}/assets/300limit.png)

> Your RSS Feed contains exactly 300 episodes, which may indicate that thee feed is limited to the 300 latest episodes. If that number looks correct, please continue. Otherwise, remove the  feed limit from your current podcast host and restart the import process.

BlogTalkRadio doesn't have a button I can click or a field I can enter to change that, so I reached out to support. 

Transistor makes this really easy, and this is also the place where you can update the new feed when you leave Transistor.

![Transistor Feed Limit is easy to know what to do]({{ site.url }}/assets/transistorFeedLimit.png)

Unfortunately, BlogTalkRadio doesn't have a good helpdesk section on this topic, and I can't find anything on my multiple google searches. 

The best I could find is that [BluBrry offers](https://blubrry.com/support/move-to-blubrry/moving-blog-talk-radio/) a helpdesk article on this topic, but here's the crazy thing: according to Blubrry, BlogTalkRadio does not offer a 301 redirect. I got a whiff of this from their announcement: 

> we do want to let you know about our sister company Spreaker, where we can place an easy redirect to ensure the safety of your podcast. We can also offer a great discount if you are interested in any of the available plans. [Via Podnews](https://podnews.net/article/blogtalkradio-customer-email)

This is reprehensible that they don't offer a 301 redirect. 
## Why is a 301 Redirect important? 
A 301 redirect makes it so your audience follows you to the new platform. Without a proper 301 redirect, you will have to build your audience from scratch. 

For example, the Blubrry help article suggests this: 
> Unfortunately, Blog Talk Radio does not give you a way to do a 301 redirect of your podcast feed away from their service. The best way to keep *most* of your subscribers to do the following:
> Resubmit your NEW podcast feed to iTunes using a slightly different name (to be changed back after it’s approved).
> 30 days before you quit uploading to Blog Talk Radio, record two versions of your podcast episodes:   one normal and one that you will have an announcement at the beginning of the show that says, “If you are hearing this, you will not receive the new episodes after xxx date. I am moving the feed and the new feed is available at <your website address>.”  Make sure you have your RSS feed available on your website and/or in your post for each episode.  Also put the announcement at the end of the podcast episode.

This kind of behavior really frustrates me. It's hostile to the user and not fair to those who don't understand how this technology works. 

To be a successful podcaster, you shouldn't have to know all the details, because you should be able to trust the companies that are making these products available! 

This is the kind of lock-in that has no place on the open web. See [[Don't call it a Substack. - Anil Dash|Don't Call it a Substack]]. 

I'll update this as the process continues. 


## How to remove the Feed Limit in BlogTalkRadio Podcast Feeds
*Updated November 23, 2024*

Today, BlogTalkRadio shared that if you replace the `www` with `beta` in your podcast feed, it will come over.

```
- Replace the `www.` in your BlogTalkRadio RSS feed URL https://www.blogtalkradio.com/YourShowName/podcast with `beta.`

For example, your updated RSS feed would look like this:

`https://beta.blogtalkradio.com/YourShowName/podcast
```

Unfortunately, this brought all the episodes over but it did not include any audio files, as "- **2000 Episodes** [were] missing an audio file or have an unreachable audio file URL."
