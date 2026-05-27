#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_root="$(mktemp -d "${TMPDIR:-/tmp}/apex-seo-migration.XXXXXX")"

cleanup() {
  rm -rf "$build_root"
}

trap cleanup EXIT

bundle exec jekyll build \
  --source "$repo_root" \
  --destination "$build_root/site" \
  --disable-disk-cache \
  --quiet >/dev/null

assert_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "Expected file to exist: $path"
    exit 1
  fi
}

assert_contains() {
  local path="$1"
  local expected="$2"
  if ! grep -Fq "$expected" "$path"; then
    echo "Expected $path to contain: $expected"
    exit 1
  fi
}

assert_not_contains() {
  local path="$1"
  local unexpected="$2"
  if grep -Fq "$unexpected" "$path"; then
    echo "Expected $path not to contain: $unexpected"
    exit 1
  fi
}

site="$build_root/site"

assert_file "$site/index.html"
assert_contains "$site/index.html" 'https://jethrojones.com/'
assert_not_contains "$site/index.html" 'localhost:4000'
assert_not_contains "$site/index.html" 'https://jethro.site'
assert_not_contains "$site/index.html" 'https://www.jethrojones.com'

assert_file "$site/bestai.html"
assert_file "$site/best-ai-tools/index.html"
assert_contains "$site/best-ai-tools/index.html" '/bestai'

assert_file "$site/presentations.html"
assert_file "$site/speaking/index.html"
assert_contains "$site/speaking/index.html" '/presentations'
assert_file "$site/present/index.html"
assert_contains "$site/present/index.html" '/presentations'

assert_file "$site/buy.html"
assert_file "$site/paperless-principal-now-available/index.html"
assert_contains "$site/paperless-principal-now-available/index.html" '/buy'

assert_file "$site/students-who-thrive.html"
assert_file "$site/sdl-students-who-thrive/index.html"
assert_contains "$site/sdl-students-who-thrive/index.html" '/students-who-thrive'

assert_file "$site/_redirects"
assert_contains "$site/_redirects" 'https://www.jethrojones.com/* https://jethrojones.com/:splat 301!'
assert_contains "$site/_redirects" 'https://jethro.site/* https://jethrojones.com/:splat 301!'
assert_contains "$site/_redirects" '/gregory-leavitt https://transformativeprincipal.org/s2/66 301!'
assert_contains "$site/_redirects" '/podcast/episode367 https://transformativeprincipal.org/s8/367 301!'
assert_contains "$site/_redirects" '/best-ai-tools https://jethrojones.com/bestai 301!'
assert_contains "$site/_redirects" '/speaking https://jethrojones.com/presentations 301!'
assert_contains "$site/_redirects" '/paperless-principal-now-available https://jethrojones.com/buy 301!'
assert_contains "$site/_redirects" '/sdl-students-who-thrive https://jethrojones.com/students-who-thrive 301!'
assert_contains "$site/_redirects" '/akprincipals2015 https://jethrojones.com/2024/10/29/akprincipals2015/ 301!'
assert_contains "$site/_redirects" '/new-products/communication-cards https://jethrojones.com/communication-cards 301!'
assert_file "$site/mediakit.html"

assert_file "$site/video-sitemap.xml"
assert_contains "$site/video-sitemap.xml" '<video:video>'
assert_contains "$site/video-sitemap.xml" 'https://jethrojones.com/inspiration/2024/12/04/blowing-out-candles/'

watch_page="$site/inspiration/2024/12/04/blowing-out-candles/index.html"
assert_file "$watch_page"
assert_contains "$watch_page" 'application/ld+json'
assert_contains "$watch_page" '"@type":"VideoObject"'
assert_contains "$watch_page" 'https://www.youtube.com/embed/jqqXL6l_Lq0'
assert_contains "$watch_page" 'https://img.youtube.com/vi/jqqXL6l_Lq0/hqdefault.jpg'

instagram_page="$site/inspiration/2025/05/23/Free-ride-home-from-school/index.html"
assert_file "$instagram_page"
assert_contains "$instagram_page" 'class="instagram-media"'

x_page="$site/inspiration/2025/01/16/Greatness-comes-from-character/index.html"
assert_file "$x_page"
assert_contains "$x_page" 'class="twitter-tweet"'

transistor_page="$site/inspiration/2025/03/25/Staying-Inspired-in-Education-Danielle-Nuhfer/index.html"
assert_file "$transistor_page"
assert_contains "$transistor_page" 'https://share.transistor.fm/e/d57537f0'

assert_file "$site/feed_notes.xml"
assert_not_contains "$site/feed_notes.xml" 'https://jethro.site/'

assert_file "$site/robots.txt"
assert_contains "$site/robots.txt" 'Sitemap: https://jethrojones.com/sitemap.xml'
assert_contains "$site/robots.txt" 'Sitemap: https://jethrojones.com/video-sitemap.xml'

echo "Apex SEO migration build output is canonicalized, redirected, and video-index ready."
