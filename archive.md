---
layout: page
title: Archive
---

<div class="archive">
  {% for post in site.posts %}
    {% assign curr_year = post.date | date: "%Y" %}
    {% if curr_year != year %}
      <h2>{{ curr_year }}</h2>
      {% assign year = curr_year %}
    {% endif %}
      <a href="{{ post.url }}">{{ post.title }}</a>
      <date>{{ post.date | date_to_string }}</date>
      <br>
  {% endfor %}
</div>