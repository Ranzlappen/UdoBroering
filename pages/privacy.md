---
layout: page
title: Privacy Policy
subtitle: How your data is handled
permalink: /privacy/
---

# Privacy Policy

**Last updated: {{ 'now' | date: '%B %Y' }}**

## Overview

This website respects your privacy. It is a static blog with no accounts, no
analytics, and no first-party cookies. Here's exactly what (little) data is
involved and why.

## Static Hosting (GitHub Pages)

This site is hosted on **GitHub Pages**. GitHub may collect basic server logs
(IP addresses, browser info) as part of their hosting service.
**Legal basis:** Legitimate interest (technical provision of the site).
Further information: [GitHub Privacy Statement](https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement).

## Search & Charts (Lunr.js & Chart.js via CDN)

The site's full-text search loads **Lunr.js** from the unpkg CDN, and blog posts
that include charts load **Chart.js** from the jsDelivr CDN. Both libraries run
entirely in your browser; loading them from a CDN exposes your IP address and
browser info to that CDN. Both are blocked until you grant functional consent.
**Legal basis:** Consent.

## Read Aloud

The read-aloud feature uses the browser's built-in **Web Speech API**. No data
is sent to any external service — everything happens locally.

## Analytics

This site does **not** use Google Analytics or any other tracking/analytics
service. No tracking cookies are set.

## Cookie Consent Banner

This site implements a **cookie consent banner**. Third-party scripts are
**blocked by default** and only loaded after your explicit consent. You can
change your choice at any time via the “Cookie Settings” link in the footer.
Consent is stored in `localStorage` under the key `cookie_consent` for 365 days.

- **Essential** (always active): `localStorage` for theme preference, view mode,
  and your consent choice.
- **Functional Services** (opt-in): Lunr.js/unpkg (search) and Chart.js/jsDelivr
  (charts on posts).

## Cookies & Local Storage

This site does not set any first-party cookies. It only uses `localStorage`,
which stays on your device and is never transmitted. The site's own
`localStorage` keys are:

- `theme` — light/dark theme preference
- `viewMode` — blog image view mode (e.g. carousel)
- `headerSticky` — whether the site header stays pinned
- `cookie_consent` — your consent choice (kept for 365 days)

## Third-Party Services Summary

| Service | Purpose | Data collected | Sets cookies? |
|---|---|---|:---:|
| **GitHub Pages** | Hosting | Server logs | No |
| **unpkg CDN** | Search library (Lunr.js) delivery | IP address, browser info | No |
| **jsDelivr CDN** | Chart library (Chart.js) delivery | IP address, browser info | No |

## Your rights (data subject rights)

You have the right to access, rectification, erasure, restriction, objection,
data portability, and withdrawal of consent at any time (via “Cookie Settings”
in the footer). Since no personal data is permanently stored on this site's
infrastructure, there is little to act on.

## Changes to this privacy policy

This policy may be updated if necessary. The current version is always available
on this page. Changes are marked with a new “Last updated” date.

*Last updated: {{ 'now' | date: '%B %Y' }}*
