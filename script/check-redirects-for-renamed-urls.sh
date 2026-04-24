#!/usr/bin/env bash
set -euo pipefail

base_ref="${1:-origin/main}"
repo_root="$(git rev-parse --show-toplevel)"
tmp_root="$(mktemp -d "${TMPDIR:-/tmp}/redirect-url-check.XXXXXX")"

cleanup() {
  rm -rf "$tmp_root"
}

trap cleanup EXIT

base_source="$tmp_root/base-source"
current_source="$tmp_root/current-source"
base_site="$tmp_root/base-site"
current_site="$tmp_root/current-site"
base_urls="$tmp_root/base-urls.txt"
current_urls="$tmp_root/current-urls.txt"
missing_urls="$tmp_root/missing-urls.txt"

mkdir -p "$base_source" "$current_source" "$base_site" "$current_site"

git -C "$repo_root" rev-parse --verify "$base_ref^{commit}" >/dev/null
git -C "$repo_root" archive "$base_ref" | tar -x -C "$base_source"

rsync -a --delete \
  --exclude '.git' \
  --exclude '.jekyll-cache' \
  --exclude '.sass-cache' \
  --exclude '_site' \
  "$repo_root/" "$current_source/"

build_site() {
  local source_dir="$1"
  local destination_dir="$2"

  (
    cd "$source_dir"
    bundle exec jekyll build \
      --source "$source_dir" \
      --destination "$destination_dir" \
      --disable-disk-cache \
      --quiet >/dev/null
  )
}

collect_html_urls() {
  local site_dir="$1"
  local output_file="$2"

  find "$site_dir" -type f -name '*.html' -print |
    sed "s|^$site_dir||" |
    sed 's|/index.html$|/|' |
    sed 's|\.html$||' |
    sort -u >"$output_file"
}

build_site "$base_source" "$base_site"
build_site "$current_source" "$current_site"

collect_html_urls "$base_site" "$base_urls"
collect_html_urls "$current_site" "$current_urls"

comm -23 "$base_urls" "$current_urls" >"$missing_urls"

if [[ -s "$missing_urls" ]]; then
  echo "WARNING: URLs existed in $base_ref but are missing from the current build."
  echo "Add redirect_from entries to the renamed content, or preserve the original permalink."
  echo

  while IFS= read -r url; do
    echo "::warning title=Missing redirect_from::$url existed in $base_ref but no page or redirect was generated in the current build."
    echo "  - $url"
  done <"$missing_urls"

  exit 1
fi

echo "No missing URLs compared with $base_ref."
