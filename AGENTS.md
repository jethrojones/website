# Codex Instructions for jethrojones/website

## Project Shape
- Jekyll static site deployed to netlify on push to github.
- Primary content lives in `_notes/`; `_posts/` is legacy and may not exist.
- Do not edit generated output in `_site/`, `.jekyll-cache/`, `.netlify/`, or `.bundle/`.
- Do not revert user-authored content changes. This repo often has many note edits in progress.

## Setup
- Ruby dependencies: `bundle install`
- Netlify build command: `bundle install --jobs 4 --retry 3 && bundle exec jekyll build --trace`

## Verification Ladder
- For most site/content/template changes:
  - `bundle exec jekyll build --destination /tmp/jethro-website-build --disable-disk-cache`
- For redirect or URL changes:
  - `bash script/test-redirect-guard.sh`
  - `bash script/test-posts-to-notes-migration.sh`
- Before running legacy smoke scripts, verify their fixtures match the current content model. Some older scripts still assume `_posts/` exists.
- Keep build destinations outside the repo unless the task specifically requires inspecting `_site/`.

## Git and Deploy
- Remote: `https://github.com/jethrojones/website.git`
- Default branch: `main`
- After pushing web changes, verify on Netlify (typical build time is bout 5 minutes total from push.), then verify the live URL or changed page.
- If GitHub auth is needed, use the active account unless a Life Lab repo instruction explicitly says otherwise.

## Common Pitfalls
- Do not commit `.bundle/`, `.netlify/`, `_site/`, `.jekyll-cache/`, or temporary build output.
- When renaming pages or changing permalinks, preserve old URLs with `redirect_from`.
- For public notes generated from private session history, keep summaries public-safe and avoid quoting private operational details.
