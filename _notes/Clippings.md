---
last_modified_at: 2024-11-11 23:59:02
permalink: clippings
description: 
title: 
image: 
published: "true"
sitemap: "true"
excerpt_separator: <!--more-->
category: 
tags: 
creation date: 2024-11-11 12:47
layout: note
---
{% if page.image %} <img src="{{ page.image }}" alt=""> {% endif %}

Clippings are things that I clip from the internet that I find interesting. 

{% assign clippings = site.notes | where: "tags", "clippings" %}
{% if clippings.size > 0 %}
  <h2>Clippings</h2>
  <ul>
    {% for clipping in clippings %}
      <li>
        <a href="{{ clipping.url }}">{{ clipping.title }}</a>
        <span>{{ clipping.date | date: "%B %d, %Y" }}</span>
      </li>
    {% endfor %}
  </ul>
{% else %}
  <p>No clippings found.</p>
{% endif %}

