---
last_modified_at: 2024-12-05 04:44:46
permalink: /blog/
description: 
title: Blog
image: 
published: "true"
sitemap: "true"
excerpt_separator: <!--more-->
category: 
tags: 
date: 2024-11-11 16:12
layout: page
---
<h1>Blog Posts</h1>

<ul>
  {% for post in paginator.posts %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <span class="post-date">{{ post.date | date: "%B %d, %Y" }}</span>
    </li>
  {% endfor %}
</ul>

<div class="pagination">
  {% if paginator.previous_page %}
    <a href="{{ paginator.previous_page_path | relative_url }}">&laquo; Previous</a>
  {% endif %}
  {% if paginator.next_page %}
    <a href="{{ paginator.next_page_path | relative_url }}">Next &raquo;</a>
  {% endif %}
</div>
