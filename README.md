# Jekyll Blog (clean starter)

A minimal, SEO-friendly **Jekyll blog**, hosted on GitHub Pages. Dark/light theme,
installable PWA + offline support, RSS, full SEO metadata (jekyll-seo-tag + JSON-LD
+ Open Graph/Twitter cards), a custom status-filtered sitemap & feed, categories,
tags, series, and client-side search over your own posts.

This is a clean fork of a larger site — stripped down to just the blog framework.
No external apps, no Firebase, no comments backend, no branding yet.

## Quick start

```bash
bundle install
bundle exec jekyll serve        # http://localhost:4000/
```

## Make it yours

1. **Identity** — edit `_config.yml`: `title`, `tagline`, `description`, and
   `author.*` (leave a social handle blank to hide its footer icon). All templates,
   SEO tags, the feed, and the manifest read from these variables.
2. **Hosting** — served from the custom apex domain **`udobroering.de`** (see the
   `CNAME` file), so `url: https://udobroering.de` and `baseurl: ""` (root). If you
   ever drop the custom domain and serve from `https://ranzlappen.github.io/UdoBroering/`
   instead, set `baseurl: "/UdoBroering"` — it must match the repo name's exact case,
   since GitHub Pages paths are case-sensitive (a wrong-case baseurl 404s every asset).
3. **Icons** — the files in `/icons/` (and `assets/images/icon_alpha.png`, the header
   logo) are **placeholders**. Replace them with your own brand art (same filenames).
4. **First post** — `_posts/2026-06-06-welcome-to-your-new-blog.md` is a blueprint
   that documents every front-matter field. Copy it, then delete it.

## Writing a post

Create `_posts/YYYY-MM-DD-slug.md` with front matter:

```yaml
---
title: "My Post"
description: "One-line summary used for SEO and cards."
date: 2026-06-06
category: "Guides"        # exactly "Projects" → /projects/, anything else → /articles/
tags: [example, jekyll]
image: /assets/images/my-post/my-post-hero.webp     # card cover (optional)
backdrop: /assets/images/my-post/my-post-hero.webp  # parallax hero (optional)
status: published          # published | draft | placeholder | unpublished
---
```

- **Status**: only `published` and `placeholder` appear in the feed and sitemap.
- **Hero images** live at `/assets/images/<slug>/<slug>-hero.webp` — genuine WebP,
  ~1280px wide, ≤50 KB (`cwebp -q 80 -m 6 -metadata none in.png -o out.webp`).
- **Series**: define one in `_data/series.yml`, then set `series:`/`series_order:`.

## Publishing a paper (PDF)

The **Papers** section (`/papers/`) auto-lists every PDF in `assets/papers/`:

1. Drop your PDF into **`assets/papers/`** — name it `YYYY-MM-DD-short-title.pdf`
   so papers sort newest-first. That's it; it appears on `/papers/` automatically.
2. *(Optional)* add a nicer title, authors, date, and abstract by keying an entry
   to the **exact filename** in **`_data/papers.yml`**:

   ```yaml
   "2026-06-06-my-paper.pdf":
     title: "A Better Title Than the Filename"
     authors: "Udo Bröring"
     date: 2026-06-06
     description: "Short abstract shown under the title."
   ```

   Without an entry, the paper still lists using its filename.

   > Once your PDF is merged to `main`, the **`sync-papers`** workflow appends a
   > pre-filled stub for it to `_data/papers.yml` automatically (with the date parsed
   > from the filename) — so step 2 becomes "edit the generated stub" rather than
   > "write one from scratch." You can also run it locally: `ruby script/sync_papers.rb`.

## Project structure

```
_config.yml          # Site config + identity variables
_data/pages.yml      # Nav + footer registry (single source of truth)
_data/series.yml     # Post series definitions
_data/papers.yml     # Optional metadata for the PDFs in assets/papers/
_layouts/            # default, home, page, post
_includes/           # head, header, footer, hero, search-modal, cards, toc, series-nav
_posts/              # Your Markdown posts
pages/               # Static pages (articles, papers, projects, categories, tags, about, privacy, disclaimer)
assets/papers/       # Published PDFs (auto-listed at /papers/)
assets/css|js|images # style.css + cookie-consent.css; main/search/carousel/charts/read-aloud/share JS
icons/               # Favicons + PWA icons (placeholders — replace)
feed.xml sitemap.xml search.json robots.txt site.webmanifest sw.js offline.html 404.html
```

## Deployment

Push to `main` → `.github/workflows/jekyll-gh-pages.yml` builds with Jekyll and
deploys to GitHub Pages. **One-time setup:** in the repo, go to *Settings → Pages →
Build and deployment → Source: GitHub Actions*.

A second workflow, `.github/workflows/sync-papers.yml`, watches `assets/papers/**` on
`main` and auto-commits stub `_data/papers.yml` entries for newly added PDFs (see
*Publishing a paper* above).

## License

MIT — see [`LICENSE`](./LICENSE).
