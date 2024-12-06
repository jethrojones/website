---
last_modified_at: 2024-12-05 05:10:55
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
layout: post
---
<h1>Blog Posts</h1>


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
