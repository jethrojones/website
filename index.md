---
last_modified_at: 2024-12-05 05:10:56
layout: page
title: Home
id: home
permalink: /
---

# Have a Good Life.

I host the longest running, most downloaded, highest rated podcast for educational leaders [Transformative Principal](https://transformativeprincipal.org) and a bunch of other podcasts. 

This web site is my experiment, constantly evolving and changing. 

See what I'm up to now on my [now page]({{ site.baseurl }}/now)

You can learn more about me at my Link-in-Bio page: [jethrojon.es](https://jethrojon.es)

## Notes vs. Blog Posts
As of today, I'm in a transition point. I have taken plain text notes since 2009!

In early 2024, I decided to make my note-taking app, [Obsidian](https://obsidian.md), the engine behind my blog posts. I wanted everything to be in one place, here at jethro.site.

So, the notes are notes that I take and occasionally update. They are linked together as you can see from the graph view on the bottom of each post page. 

The blog posts are posts that I wrote many years ago, going all the way back to 2006, when I started blogging. 

I don't know if I'll migrate all my old blog posts over to "notes" or if they'll just stay as blog posts. It's all an experiment. 

See below for my most recently updated notes.

## Recently updated notes

<ul>
  {% for note in page.paginated_notes %}
    <li>
      {{ note.last_modified_at | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>

{% if page.notes_paginator.total_pages > 1 %}
<div class="pagination">
  {% if page.notes_paginator.previous_page_path %}
    <a href="{{ site.baseurl }}{{ page.notes_paginator.previous_page_path }}">&laquo; Previous</a>
  {% endif %}
  {% if page.notes_paginator.next_page_path %}
    <a href="{{ site.baseurl }}{{ page.notes_paginator.next_page_path }}">Next &raquo;</a>
  {% endif %}
</div>
{% endif %}



## These are all the blog posts from my Blogger and Squarespace Blogs
<style>
.blog-posts {
  font-family: Arial, sans-serif;
}

.year-details, .month-details {
  margin-bottom: 1em;
}

.year-summary, .month-summary {
  cursor: pointer;
  background-color: #f0f0f0;
  padding: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
}

.year-summary:hover, .month-summary:hover {
  background-color: #e0e0e0;
}

.month-list {
  padding-left: 20px; /* Indent month list */
}

.post-list {
  list-style-type: none; /* Remove bullet points */
  padding-left: 0; /* Remove default padding */
}

.post-list li {
  margin: 5px 0; /* Space between posts */
}

.post-date {
  font-size: 0.9em; /* Smaller font for date */
  color: #666; /* Lighter color for date */
}
</style>
{% assign postsByYear = site.posts | group_by_exp:"post", "post.date | date: '%Y'" %}

<div class="blog-posts">
  {% for year in postsByYear %}
  <details class="year-details">
    <summary class="year-summary">{{ year.name }}</summary>
    
    {% assign postsByMonth = year.items | group_by_exp:"post", "post.date | date: '%B'" %}
    
    <div class="month-list">
      {% for month in postsByMonth %}
      <details class="month-details">
        <summary class="month-summary">{{ month.name }}</summary>
        <ul class="post-list">
          {% for post in month.items %}
          <li>
            <a href="{{ post.url }}">{{ post.title }}</a>
            <span class="post-date">{{ post.date | date: "%B %d, %Y" }}</span>
          </li>
          {% endfor %}
        </ul>
      </details>
      {% endfor %}
    </div>
  </details>
  {% endfor %}
</div>

Have a Good Life.

<style>
  .wrapper {
    max-width: 46em;
  }
</style>
