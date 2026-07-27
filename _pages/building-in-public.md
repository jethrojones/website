---
layout: page
title: Building in public
description: Daily AI-assisted build logs from Jethro Jones, plus Build in Public Daily.
permalink: /building-in-public
last_modified_at: 2026-07-27 17:32:28
---

Short daily logs of what I shipped with AI. These notes are produced with automation, then published here. They may be thin, wrong in spots, or boring. That is the point of a public log, not a polished essay.

When [Build in Public Daily](https://bipd.bepodcast.network) is active again, episode links will land with the matching day's note.

## Recent logs

<ul>
{% assign base_notes = site.notes | where_exp: "n", "n.content_type != 'post' and n.content_type != 'post_archive'" %}
{% assign notes_by_date = base_notes | sort: "date" | reverse %}
{% for note in notes_by_date %}
  {% assign is_witb = false %}
  {% if note.tags contains "what-i-built-today" %}{% assign is_witb = true %}{% endif %}
  {% if note.title contains "What I Built Today" %}{% assign is_witb = true %}{% endif %}
  {% if is_witb %}
  {% assign note_date = note.date | default: note.last_modified_at %}
  <li>
    {{ note_date | date: "%Y-%m-%d" }} —
    <a class="internal-link" href="{{ note.url | relative_url }}">{{ note.title }}</a>
  </li>
  {% endif %}
{% endfor %}
</ul>

<p><a href="https://bipd.bepodcast.network">Build in Public Daily podcast</a> · <a class="internal-link" href="/">Home</a> · <a class="internal-link" href="/projects">Projects</a></p>

Have a Good Life.
