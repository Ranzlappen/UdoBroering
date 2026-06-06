---
title: "Welcome to Your New Blog"
description: "A blueprint post that demonstrates every front-matter field and writing convention this Jekyll blog supports — copy it to start your own posts."
keywords: ["jekyll", "blog template", "getting started", "markdown", "front matter"]
date: 2026-06-06
category: "Guides"
tags: [getting-started, jekyll, template]
image: /assets/images/welcome/welcome-hero.svg
backdrop: /assets/images/welcome/welcome-hero.svg
status: published
series: "getting-started"
series_order: 1
---

Welcome! This post is the **blueprint** for everything you'll write here. It is a
real, published post — and it doubles as living documentation. Duplicate this file
(`_posts/2026-06-06-welcome-to-your-new-blog.md`), change the front matter, replace
the body, and you have a new post.

## Front matter, field by field

Every post starts with a YAML front-matter block between `---` fences. Here's what
each field does:

| Field | Required | What it does |
|---|:---:|---|
| `title` | ✅ | Shows in the card, the post header, the `<title>`, and all SEO/OG tags. |
| `description` | ✅ | Meta description, card blurb, and feed summary. Keep it under ~155 chars. |
| `keywords` | — | SEO keyword array. |
| `date` | ✅ | `YYYY-MM-DD`. Drives the URL and sort order. |
| `category` | ✅ | A single string. **`"Projects"`** (exact case) routes the post to `/projects/`; anything else lands on `/blog/`. |
| `tags` | — | Array of tags. Each becomes a filter on `/tags/`. |
| `image` | — | Card cover, rendered 600×340. Convention: `/assets/images/<slug>/<slug>-hero.*`. |
| `backdrop` | — | Full-bleed parallax hero at the top of the post page. Usually the same file as `image`. |
| `status` | — | `published` (default), `draft`, `placeholder`, or `unpublished`. Only `published` and `placeholder` appear in the feed and sitemap. |
| `series` / `series_order` | — | Group related posts. Define the series in `_data/series.yml`; the post page then shows a “Part X of Y” navigator. |

## Categories vs. tags

- **Category** is singular and routes the post. Use `category: "Projects"` to send a
  post to the `/projects/` page; use anything else (like `"Guides"` here) for `/blog/`.
- **Tags** are plural and cross-cutting. They power `/tags/` and the “You might also
  like” related-posts block.

## Hero images

Drop a hero image at `/assets/images/<slug>/<slug>-hero.webp` and point both `image`
and `backdrop` at it. Real photos should be **genuine WebP**, ~1280px wide, metadata
stripped, target ≤50 KB:

```bash
cwebp -q 80 -m 6 -metadata none in.png -o out.webp
```

SVG heroes (like the placeholder this post uses) are already tiny and need no
optimization.

## Writing the body

Just write Markdown. Tables (like the one above), code blocks, blockquotes, and
images all get styled automatically by `assets/css/style.css`.

> Blockquotes look like this — handy for asides and callouts.

```js
// Code blocks get syntax highlighting via Rouge.
function greet(name) {
  return `Hello, ${name}!`;
}
```

That's it. Delete this post (or set `status: draft`) once you've written your own.
Happy blogging!
