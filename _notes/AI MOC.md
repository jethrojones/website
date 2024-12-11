---
last_modified_at: 
permalink: ai
description: 
title: Everything AI
image: /assets/aplus.jpeg
sitemap: "true"
excerpt_separator: <!--more-->
category: 
tags: 
layout: page
---


{% if page.image %} <img src="{{ page.image }}" alt=""> {% endif %}
# Everything AI
This is the place to find everything about AI on my site:

<div style="font-size: 0.9em; margin-top: 2em;">
  <h3 style="margin-bottom: 1em">Notes mentioning this note</h3>
  {% assign target_page = site.pages | where: "title", "AI MOC.md" | first %}
  {% if target_page and target_page.backlinks.size > 0 %}
  <div style="display: grid; grid-gap: 1em; grid-template-columns: repeat(1fr);">
    {% for backlink in target_page.backlinks %}
      <div class="backlink-box">
        <a class="internal-link" href="{{ site.baseurl }}{{ backlink.url }}{%- if site.use_html_extension -%}.html{%- endif -%}">{{ backlink.title }}</a><br>
        <div style="font-size: 0.9em">{{ backlink.excerpt | strip_html | truncatewords: 20 }}</div>
      </div>
    {% endfor %}
  </div>
  {% else %}
  <div style="font-size: 0.9em">
    <p>
      There are no notes linking to this note.
    </p>
  </div>
  {% endif %}
</div>

Blog Posts:
- [Testing a couple different solutions with AI](https://jethro.site/podcast/2023/12/22/testing-a-couple-different-solutions-with-ai/)
- [How AI Is Relieving Burdens on Educators](https://jethro.site/2023/12/12/how-ai-is-relieving-burdens-on-educators/)
- [Student AI Usage](https://jethro.site/2023/11/13/student-ai-usage/)

## AILeader Office Hours
- [November 2024 - Adjusting Schedules](https://jethro.site/aiofficenov24)
- 