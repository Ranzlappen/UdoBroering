# udobroering — Jekyll blog

A minimal personal blog built with **Jekyll** and hosted on GitHub Pages. This is a
clean, blog-only fork of a larger multi-app site: no PolyVote, no Blog Admin, no
Inventory Manager, no Firebase, no Giscus comments, no search crawler, and no
branding yet (identity is driven by `_config.yml` variables).

## Architecture

A single Jekyll static site. There is no build step beyond Jekyll itself and no
JavaScript framework — `assets/js/*.js` are small vanilla-JS enhancements.

- **Content**: posts in `_posts/`, static pages in `pages/`.
- **Templates**: layouts in `_layouts/` (`default`, `home`, `page`, `post`),
  partials in `_includes/`.
- **Config & data**: `_config.yml`; navigation in `_data/pages.yml`; series in
  `_data/series.yml`.
- **Styling**: one main stylesheet `assets/css/style.css` (+ `cookie-consent.css`),
  CSS-custom-property driven, with a dark (default) / light theme toggle.

## Build & Development

```bash
bundle install
bundle exec jekyll serve        # local dev server at http://localhost:4000/
bundle exec jekyll build        # production build into _site/
```

## Key conventions

- **Identity is variable-driven**: `title`, `tagline`, `description`, and `author.*`
  live in `_config.yml`. Templates, SEO/OG tags, the feed, and the manifest all read
  these — there is no hardcoded site name in templates. The `/icons/` set is a placeholder Φ; the header shows a Φ glyph (no logo image).
  
- **Hosting**: custom apex domain **`udobroering.de`** (`CNAME` file) — served at the
  domain root, so `url: https://udobroering.de` and `baseurl: ""`. `sw.js` and
  `site.webmanifest` are baseurl-aware. If you ever drop the custom domain and serve
  from `https://ranzlappen.github.io/UdoBroering/` again, set `baseurl: /UdoBroering`
  (must match the repo name's exact case — GitHub Pages paths are case-sensitive, so a
  wrong-case baseurl 404s every asset).
- **Post status**: `status` front-matter field — `published` (default), `draft`,
  `placeholder`, `unpublished`. Only `published` and `placeholder` appear in the
  feed (`feed.xml`) and sitemap (`sitemap.xml`).
- **Post categories**: singular `category:` field. The exact string `"Projects"`
  routes a post to `/projects/`; everything else lands on `/articles/`. Liquid `==` is
  case-sensitive — keep the casing.
- **Post hero images**: `image:` (card cover, 600×340) and `backdrop:` (parallax
  hero) live at `/assets/images/<slug>/<slug>-hero.webp` — genuine WebP, ~1280px,
  ≤50 KB (`cwebp -q 80 -m 6 -metadata none in.png -o out.webp`). SVG heroes are fine
  as-is. The homepage warms the browser cache with these (see `_layouts/home.html`).
- **Navigation**: centralized in `_data/pages.yml` — single source of truth for the
  header, mobile nav, and footer. `menu: [main]`, `[footer]`, or `[main, footer]`.
- **Series**: define in `_data/series.yml`; a post opts in with `series:` +
  `series_order:` and gets a “Part X of Y” navigator (`_includes/series-nav.html`).
- **Papers (PDFs)**: `pages/papers.html` (`/papers/`) auto-lists every PDF in
  `assets/papers/` by iterating `site.static_files` — drop a PDF in and it appears
  (name it `YYYY-MM-DD-title.pdf` to sort newest-first). Optional richer metadata
  (`title`, `authors`, `date`, `description`) lives in `_data/papers.yml`, keyed by
  the exact PDF filename; without an entry the bare filename is used. When a new PDF
  lands on `main`, the deploy workflow's **`prepare`** job runs `script/sync_papers.rb`
  to append a ready-to-fill stub entry for it (date parsed from the filename prefix)
  and commits it back *before* the build — purely a convenience, since the page lists
  the PDF regardless. Run it locally any time with `ruby script/sync_papers.rb`.
- **Search**: `Ctrl/Cmd+K` modal (`_includes/search-modal.html` + `assets/js/search.js`)
  runs **client-side Lunr** over **`_posts` only**, indexed by the Liquid-generated
  `search.json`. It loads Lunr from a CDN behind the functional-cookie consent gate —
  keep it that way; do not add a query-time third-party search service.
- **Privacy-first**: no analytics, no first-party cookies, no Firebase/Giscus. The
  only consent-gated third parties are the Lunr CDN (search) and the Chart.js CDN
  (charts on posts). GDPR cookie consent with a functional category.
- **Theme**: "Marble & Ink" — charcoal/marble greys with a bronze accent (and an
  oxblood secondary, `--c-accent-2`). **Light "gallery" is the default** (set pre-paint
  in `_includes/head.html` — `data-theme="light"` unless `localStorage.theme === 'dark'`);
  a dark "study" mode toggles via `<html data-theme>` (absence of the attribute = dark).
  The `theme-color` meta + manifest default to the light bg. Palette + fonts are driven
  by the `:root` (dark base) / `[data-theme="light"]` custom properties, so recoloring is
  centralized. A header pin/unpin toggle controls header stickiness.
- **Fonts (self-hosted)**: serif throughout — **EB Garamond** (body, `--f-body`) and
  **Cormorant Garamond** (display headings, `--f-heading`), self-hosted as woff2 in
  `assets/fonts/` (SIL OFL) with `@font-face` + `font-display: swap` at the top of
  `style.css`. No third-party font CDN (privacy-first). The two critical weights are
  `<link rel="preload">`-ed in `_includes/head.html` and precached by `sw.js`. To add
  a weight: drop the woff2 in `assets/fonts/`, add an `@font-face`, bump `CACHE_VERSION`.
- **PWA**: installable (`site.webmanifest`, `display: standalone`) with a
  hand-written `sw.js` (precache shell + `offline.html`; cache-first static,
  network-first navigations). Bump `CACHE_VERSION` in `sw.js` when the shell changes.

## SEO

`jekyll-seo-tag` (`{% seo %}` in `_includes/head.html`) plus hand-rolled extras:
Open Graph + Twitter cards, canonical, JSON-LD (`WebSite` in head; `BlogPosting` +
`BreadcrumbList` in `_layouts/post.html`), a custom status-filtered `sitemap.xml`
and Atom `feed.xml`, and `robots.txt`.

## Deployment & CI/CD

One workflow, `.github/workflows/jekyll-gh-pages.yml`, builds with Jekyll and deploys
to GitHub Pages on push to `main` (and `workflow_dispatch`). One-time setup: *Settings
→ Pages → Source: GitHub Actions*. It runs three jobs:
- **`prepare`** (`contents: write`) — runs `script/sync_papers.rb` to scaffold
  `_data/papers.yml` stubs for any new PDFs and commits them back *before* the build,
  so the deploy reflects them. The commit uses the default `GITHUB_TOKEN`, which does
  **not** re-trigger the workflow — keeping it to a single deployment per push (folding
  this in-line avoids the earlier race where a separate sync commit kicked a second,
  colliding Pages deployment). `build` checks out the post-stub commit via the job's
  `sha` output.
- **`build`** — `bundle exec jekyll build`, uploads the Pages artifact.
- **`deploy`** — `actions/deploy-pages` to the `github-pages` environment.

`.github/dependabot.yml` keeps the `bundler` and `github-actions` ecosystems updated
weekly.

## Project structure

```
├── _config.yml              # Config + identity variables
├── _data/
│   ├── pages.yml            # Navigation registry (nav + footer)
│   ├── series.yml           # Post series definitions
│   └── papers.yml           # Optional metadata for PDFs in assets/papers/
├── _includes/               # head, header, footer, hero, search-modal,
│                            #   post-card, post-list-item, series-nav, toc
├── _layouts/                # default, home, page, post
├── _posts/                  # Blog content (Markdown)
├── pages/                   # articles, papers, projects, categories, tags, about, privacy, disclaimer
├── script/                  # sync_papers.rb (scaffolds _data/papers.yml stubs)
├── assets/
│   ├── css/                 # style.css, cookie-consent.css
│   ├── js/                  # main, cookie-consent, search, carousel, charts, read-aloud, share
│   ├── fonts/               # Self-hosted serif woff2 (EB Garamond + Cormorant Garamond)
│   ├── papers/              # Published PDFs (auto-listed at /papers/)
├── icons/                   # Favicons + PWA icons (placeholders)
├── feed.xml sitemap.xml search.json robots.txt
├── site.webmanifest sw.js offline.html 404.html index.html
└── .github/
    ├── dependabot.yml
    └── workflows/
        └── jekyll-gh-pages.yml   # prepare (papers stubs) + build + deploy to Pages
```

## Post-task self-check

After a change, scan whether it should be reflected in `README.md`, `CLAUDE.md`, the
workflow, or `dependabot.yml` (new conventions, scripts, paths). Auto-apply small
unambiguous doc updates; prompt for anything structural. Skip for pure Q&A.
