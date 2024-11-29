---
last_modified_at: 
permalink: 
description: Using ChatGPT to create search for this web site built using jekyll
image: 
published: "true"
sitemap: "true"
excerpt_separator: <!--more-->
category: "[[Clippings]]"
tags:
  - clippings
date: 2024-11-11 12:47
layout: note
author: "[[Matt Webb]]"
title: Using Vectorize to build an unreasonably good search engine in 160 lines of code
source: https://blog.partykit.io/posts/using-vectorize-to-build-search
clipped: 2024-11-11
---

[Using Vectorize to build an unreasonably good search engine in 160 lines of code](https://blog.partykit.io/posts/using-vectorize-to-build-search).
{% if page.source and page.author %}

  <p>via <a href="{{ page.source }}">{{ page.author }}</a></p>

{% endif %}
Since this site is built using Jekyll, I need to translate this to something that will be compatible for Jekyll. So I asked ChatGPT to make it work for me. I want search on this site, but that's pretty advanced for me. 

[Here's what ChatGPT](https://chatgpt.com/share/67329983-5198-800f-b381-7ebb349d7862) came back with. This is going to take me some time to figure out. So, when it's done, you'll see a search bar up on top! Or somewhere! 

I've found that I have to continually update and check back in when I use AI to help with this kind of stuff, but I think it will likely be worth it, and I'll update the steps when I figure it out! 

Here’s how to implement search using PartyKit and Vectorize on a Jekyll site hosted on Netlify:

---

**Prerequisites**

  

• A Jekyll site deployed on Netlify.

• Basic knowledge of JavaScript and Jekyll’s structure.

• PartyKit and Cloudflare account access.

  

**Step 1: Install Dependencies**

  

You’ll need the following packages:

• **PartyKit**: For deploying the search backend.

• **Vectorize**: For creating and managing vector embeddings.

  

1. Install PartyKit CLI:

  
```
npm install -g @partykit/cli
```
  

  

2. Set up a Vectorize project in Cloudflare following their documentation. This will allow you to create the embeddings for search.

  

**Step 2: Extract Content from Jekyll Site**

  

1. Create a new JavaScript file (extract-content.js) in your Jekyll project root directory. This script will extract text content from your markdown files (_posts folder) to use for search.

2. In extract-content.js, write a script to read through your Jekyll markdown files and extract the main content:

  

```
const fs = require('fs');

const path = require('path');

  

const postsDir = path.join(__dirname, '_posts');

const posts = fs.readdirSync(postsDir).map(filename => {

  const filePath = path.join(postsDir, filename);

  const content = fs.readFileSync(filePath, 'utf-8');

  const title = content.match(/title:\s*(.*)/)[1];

  const body = content.split('---')[2].trim();

  return { title, body };

});

  

fs.writeFileSync('content.json', JSON.stringify(posts, null, 2));
```
  

This script will create a content.json file with titles and content from each post.

  

**Step 3: Create Embeddings with Vectorize**

  

1. Use the content in content.json to generate vector embeddings. You’ll send each post’s content to Vectorize to create an embedding that represents the semantic meaning of the text.

2. Write a script (generate-embeddings.js) that reads from content.json and sends each post’s content to Vectorize:

  

```
const fetch = require('node-fetch');

const fs = require('fs');

  

const posts = require('./content.json');

const VECTORIZE_API = 'https://vectorize.cloudflare.com/v1/embeddings';

  

async function getEmbeddings(text) {

  const response = await fetch(VECTORIZE_API, {

    method: 'POST',

    headers: { 'Content-Type': 'application/json' },

    body: JSON.stringify({ input: text })

  });

  const data = await response.json();

  return data.embedding;

}

  

async function main() {

  for (const post of posts) {

    post.embedding = await getEmbeddings(post.body);

  }

  fs.writeFileSync('embeddings.json', JSON.stringify(posts, null, 2));

}

  

main();
```

  

This creates embeddings.json with content and vector embeddings.

  

**Step 4: Set Up PartyKit Backend**

  

1. Create a new PartyKit project:

  

```
partykit create search_backend

cd search_backend
```

  

  

2. Define a PartyKit server in index.js that will handle search queries:

  

```
import { search } from './search.js';

  

export default function (app) {

  app.get('/search', async (req, res) => {

    const query = req.query.q;

    const results = await search(query);

    res.json(results);

  });

}
```

  

  

3. In search.js, write a function to compare the query vector with post embeddings and return the best matches:

  

```
import { cosineSimilarity } from './cosine-similarity';

  

const posts = require('./embeddings.json');

  

export async function search(query) {

  const queryEmbedding = await getEmbeddings(query);

  return posts

    .map(post => ({

      ...post,

      similarity: cosineSimilarity(queryEmbedding, post.embedding)

    }))

    .sort((a, b) => b.similarity - a.similarity)

    .slice(0, 5);

}
```
  

**Step 5: Deploy PartyKit Backend**

  

1. Run the PartyKit CLI to deploy:

  
```
partykit deploy
```
  

  

2. You’ll receive a public URL to access your PartyKit backend, e.g., https://your-backend.partykit.dev.

  

**Step 6: Integrate Search Frontend in Jekyll**

  

1. Create a search page in your Jekyll site (e.g., search.html) with an input box and button for searching.

2. Add JavaScript in search.html to handle user input and call the PartyKit backend:

  


```
<input type="text" id="searchBox" placeholder="Search...">

<button onclick="performSearch()">Search</button>

<div id="results"></div>

  


<script>

  async function performSearch() {

    const query = document.getElementById('searchBox').value;

    const response = await fetch('https://your-backend.partykit.dev/search?q=' + encodeURIComponent(query));

    const results = await response.json();

    document.getElementById('results').innerHTML = results.map(post => `

      <h3>${post.title}</h3>

      <p>${post.body.slice(0, 100)}...</p>

    `).join('');

  }

</script>
```
  

**Step 7: Deploy the Updated Jekyll Site on Netlify**

  

1. Commit and push your Jekyll changes to your Git repository. Netlify will automatically rebuild your site.

2. Visit your search page on Netlify and test out the functionality.

  

**Summary**

  

You now have a Jekyll site with a vector-based search feature hosted on Netlify using PartyKit and Cloudflare’s Vectorize! This approach enables semantic search for more accurate and relevant results.