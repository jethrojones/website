---
layout: page
title: The Ultimate 2026 Inspirational Videos for Teachers and Students
description: Inspirational videos for students, teachers, principals, and educators, with individual watch pages for motivational clips and classroom-ready videos.
category:
tags:
status: publish
last_modified_at: 2026-05-14 19:34:20
date: 2020-01-01
---
Everyone needs some inspiration every once in a while. I've collected here some of the greatest motivational videos that I've found. From inspiring that makes you cry, to teacher support, to inspiring students, I hope this helps. I'm sure there's a ton more, and I hope if you find one that isn't on this page, you'll send me the
[link here](mailto:jethro@transformativeprincipal.com?subject=You're%20missing%20an%20inspirational%20video!!&body=Hey%20Jethro!%20Great%20site%2C%20but%20you're%20missing%20a%20great%20inspirational%20video.%20Here's%20the%20link%3A%20). I keep this page updated throughout the years, so check back often.

{% assign inspiration_posts = site.notes | where: "content_type", "post" | where_exp: "post", "post.categories contains 'inspiration' and post.video_url" | sort: "date" | reverse %}

## Featured Inspirational Videos

<div class="inspiration-video-list">
{% assign displayed_video_count = 0 %}
{% for post in inspiration_posts %}
{% if post.video_url contains "youtube.com" or post.video_url contains "youtu.be" %}
{% if displayed_video_count < 12 %}
  <article class="inspiration-video">
    <h3><a class="internal-link" href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
    {% include video_embed.html video_url=post.video_url metadata=post.video_metadata original_url_label="Watch on the original platform" %}
  </article>
  {% assign displayed_video_count = displayed_video_count | plus: 1 %}
{% endif %}
{% endif %}
{% endfor %}
{% for post in inspiration_posts %}
{% unless post.video_url contains "share.transistor.fm" %}
{% unless post.video_url contains "youtube.com" or post.video_url contains "youtu.be" %}
{% if displayed_video_count < 12 %}
  <article class="inspiration-video">
    <h3><a class="internal-link" href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
    {% include video_embed.html video_url=post.video_url metadata=post.video_metadata original_url_label="Watch on the original platform" %}
  </article>
  {% assign displayed_video_count = displayed_video_count | plus: 1 %}
{% endif %}
{% endunless %}
{% endunless %}
{% endfor %}
</div>

## Individual Inspirational Video Watch Pages

These pages are built for watching a single video at a time. They also give Google a clearer watch page for video indexing.

<ul>
{% for post in inspiration_posts %}
  <li><a class="internal-link" href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
{% endfor %}
</ul>

<script async data-uid="6da1a20aed" src="https://jethrojones.kit.com/6da1a20aed/index.js"></script>
