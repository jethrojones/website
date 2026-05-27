#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

ruby - <<'RUBY'
missing = []
bad_remote_images = []

Dir.glob("_notes/**/*.md") do |file|
  text = File.read(file)

  text.scan(%r{/squarespace_images/[^\s\)\]\"<>]+}) do |ref|
    bad_remote_images << "#{file}: #{ref}"
  end

  text.scan(%r{!\[[^\]]*\]\((https?://(?:static1?\.squarespace\.com|images\.squarespace-cdn\.com|squarespacecdn\.com)/[^\s\)\]\"<>]+)\)}) do |match|
    bad_remote_images << "#{file}: #{match.first}"
  end

  text.scan(%r{/assets/squarespace/[^\s\)\]\"<>]+}) do |ref|
    path = ref.sub(%r{^/}, "")
    missing << "#{file}: #{ref}" unless File.file?(path)
  end
end

if bad_remote_images.any?
  warn "Found old Squarespace image references:"
  warn bad_remote_images.join("\n")
  exit 1
end

if missing.any?
  warn "Missing migrated Squarespace assets:"
  warn missing.join("\n")
  exit 1
end
RUBY

ruby - <<'RUBY'
missing = []
in_block = false

File.readlines("_redirects", chomp: true).each do |line|
  in_block = true if line == "# BEGIN Squarespace image redirects"
  in_block = false if line == "# END Squarespace image redirects"
  next unless in_block && line.start_with?("/squarespace_images/")

  target = line.split[1]
  path = target.sub("https://jethrojones.com/", "")
  missing << line unless File.file?(path)
end

if missing.any?
  warn "Missing Squarespace image redirect targets:"
  warn missing.join("\n")
  exit 1
end
RUBY

echo "Squarespace image migration references and redirects are valid."
