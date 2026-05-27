#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "open3"
require "set"
require "shellwords"
require "uri"

REPO_ROOT = File.expand_path("..", __dir__)
ARCHIVE_DIR = "/Users/jethrojones/jethro/to add to jethro site/squarespace_images"
TARGET_DIR = File.join(REPO_ROOT, "assets", "squarespace")
MANIFEST_PATH = File.join(REPO_ROOT, "script", "squarespace-image-manifest.tsv")
REDIRECTS_PATH = File.join(REPO_ROOT, "_redirects")
NOTES_GLOB = File.join(REPO_ROOT, "_notes", "**", "*.md")
MISSING_LOCAL_SOURCE = File.join(
  REPO_ROOT,
  "assets",
  "content_v1_4fffa949e4b0b4590d67b4e7_1561585926534-TTVG6QKT5A82B8PNF55O_IMG_0572.jpeg"
)

LOCAL_REF_RE = %r{/squarespace_images/[^\s\)\]\"<>]+}
REMOTE_ASSET_RE = %r{https?://(?:static1?\.squarespace\.com|images\.squarespace-cdn\.com|squarespacecdn\.com)/[^\s\)\]\"<>]+}
IMAGE_EXT_RE = /\.(?:jpe?g|png|gif)\z/i

PBIS_KEYNOTE_URL = "http://static.squarespace.com/static/4fffa949e4b0b4590d67b4e7/t/50211c5be4b098a90b8f085b/1344347227530/"
PBIS_POWERPOINT_URL = "http://static.squarespace.com/static/4fffa949e4b0b4590d67b4e7/t/50211ab7e4b03f6f4d1a4ad6/1344346807454/"
PAPERLESS_WORKFLOW_URL = "http://static.squarespace.com/static/4fffa949e4b0b4590d67b4e7/t/502bb29cc4aa7ecb517a2184/1345041052312/"

def decode_path_component(value)
  URI::DEFAULT_PARSER.unescape(value)
rescue ArgumentError
  value
end

def ext_for_mime(path)
  mime = `file -b --mime-type #{Shellwords.escape(path)}`.strip
  case mime
  when "image/jpeg" then ".jpg"
  when "image/png" then ".png"
  when "image/gif" then ".gif"
  else ""
  end
end

def clean_target_basename(source_path)
  basename = File.basename(source_path).sub(/_+\z/, "")
  basename += ext_for_mime(source_path) if File.extname(basename).empty?
  basename
end

def find_archive_file(basename)
  candidates = [basename, basename.sub(/_+\z/, "")]
  candidates.map { |candidate| File.join(ARCHIVE_DIR, candidate) }.find { |path| File.file?(path) }
end

def archive_basename_from_remote(url)
  uri = URI.parse(url)
  path_parts = uri.path.split("/").reject(&:empty?)

  if uri.host == "images.squarespace-cdn.com" && path_parts[0, 2] == %w[content v1] && path_parts.length >= 5
    site_id = path_parts[2]
    asset_id = path_parts[3]
    filename = path_parts[4..].join("/")
    return "content_v1_#{site_id}_#{asset_id}_#{filename}"
  end

  if uri.host == "squarespacecdn.com" && path_parts[0] == "squarespace_images"
    return path_parts[1..].join("/")
  end

  nil
rescue URI::InvalidURIError
  nil
end

def remote_download_basename(url, content_type = nil)
  uri = URI.parse(url)
  basename = decode_path_component(File.basename(uri.path))
  basename = "squarespace-#{uri.path.split('/').reject(&:empty?).last}" if basename.empty? || basename == "/"

  if File.extname(basename).empty? && content_type&.start_with?("image/")
    basename += case content_type
                when "image/jpeg" then ".jpg"
                when "image/png" then ".png"
                when "image/gif" then ".gif"
                else ".img"
                end
  end

  basename
rescue URI::InvalidURIError
  nil
end

def head_content_type(url)
  stdout, _stderr, status = Open3.capture3("curl", "-L", "-I", "--max-time", "20", url)
  return nil unless status.success?

  stdout.scan(/^content-type:\s*([^;\r\n]+)/i).last&.first&.strip&.downcase
end

def download_remote_image(url, destination)
  FileUtils.mkdir_p(File.dirname(destination))
  _stdout, stderr, status = Open3.capture3("curl", "-L", "--fail", "--silent", "--show-error", "--max-time", "60", "--output", destination, url)
  raise "curl failed for #{url}: #{stderr}" unless status.success?

  destination
end

def image_width(path)
  stdout, _stderr, status = Open3.capture3("sips", "-g", "pixelWidth", path)
  return nil unless status.success?

  stdout[/pixelWidth:\s*(\d+)/, 1]&.to_i
end

def optimize_image(path)
  ext = File.extname(path).downcase
  return "unchanged-gif" if ext == ".gif"

  before_size = File.size(path)
  width = image_width(path)
  if width && width > 2000
    _stdout, stderr, status = Open3.capture3("sips", "--resampleWidth", "2000", path)
    raise "sips resize failed for #{path}: #{stderr}" unless status.success?
  end

  after_resize = File.size(path)
  tmp = "#{path}.optimized"

  if [".jpg", ".jpeg"].include?(ext)
    _stdout, _stderr, status = Open3.capture3("sips", "-s", "format", "jpeg", "-s", "formatOptions", "82", path, "--out", tmp)
    if status.success? && File.file?(tmp) && File.size(tmp).positive? && File.size(tmp) < File.size(path)
      FileUtils.mv(tmp, path)
    else
      FileUtils.rm_f(tmp)
    end
  elsif ext == ".png"
    _stdout, _stderr, status = Open3.capture3("sips", "--optimizeColorForSharing", path, "--out", tmp)
    if status.success? && File.file?(tmp) && File.size(tmp).positive? && File.size(tmp) < File.size(path)
      FileUtils.mv(tmp, path)
    else
      FileUtils.rm_f(tmp)
    end
  end

  "optimized #{before_size}->#{File.size(path)} resize_intermediate=#{after_resize}"
end

def unique_destination_for(basename)
  base = basename
  ext = File.extname(base)
  stem = base.delete_suffix(ext)
  candidate = File.join(TARGET_DIR, base)
  index = 2

  while File.exist?(candidate)
    candidate = File.join(TARGET_DIR, "#{stem}-#{index}#{ext}")
    index += 1
  end

  candidate
end

FileUtils.mkdir_p(TARGET_DIR)

markdown_files = Dir.glob(NOTES_GLOB)
manifest_rows = []
replacements = {}
redirects = {}

def add_asset_mapping(old_ref, source_path, action, manifest_rows, replacements, redirects)
  target_basename = clean_target_basename(source_path)
  target_path = File.join(TARGET_DIR, target_basename)
  target_url = "/assets/squarespace/#{target_basename}"

  FileUtils.cp(source_path, target_path) unless File.exist?(target_path)
  optimization = optimize_image(target_path)

  replacements[old_ref] = target_url
  redirects[old_ref] = "https://jethrojones.com#{target_url}" if old_ref.start_with?("/squarespace_images/")
  manifest_rows << [action, old_ref, source_path, target_url, optimization]
end

local_refs = Set.new
remote_refs = Set.new
remote_image_refs = Set.new

markdown_files.each do |file|
  text = File.read(file)
  text.scan(LOCAL_REF_RE) { |ref| local_refs << ref }
  text.scan(REMOTE_ASSET_RE) { |ref| remote_refs << ref }
  text.scan(/!\[[^\]]*\]\((#{REMOTE_ASSET_RE})\)/) { |match| remote_image_refs << match.first }
end

local_refs.sort.each do |old_ref|
  basename = old_ref.delete_prefix("/squarespace_images/")
  source = find_archive_file(basename)

  if source.nil? && basename == File.basename(MISSING_LOCAL_SOURCE) + "_"
    source = MISSING_LOCAL_SOURCE
  end

  if source
    add_asset_mapping(old_ref, source, "local_archive_image", manifest_rows, replacements, redirects)
  else
    manifest_rows << ["missing_local_image", old_ref, "", "", ""]
  end
end

remote_refs.sort.each do |url|
  if [PBIS_KEYNOTE_URL, PBIS_POWERPOINT_URL].include?(url)
    target = url == PBIS_KEYNOTE_URL ? "/assets/PBIS+as+medicine.key" : "/assets/PBIS+as+medicine.ppt"
    replacements[url] = target
    manifest_rows << ["remote_file_replaced", url, target, target, "existing local file"]
    next
  end

  unless remote_image_refs.include?(url) || url == PAPERLESS_WORKFLOW_URL
    manifest_rows << ["remote_left_external", url, "", "", "not an image embed"]
    next
  end

  archive_basename = archive_basename_from_remote(url)
  source = archive_basename && find_archive_file(decode_path_component(archive_basename))

  if source
    add_asset_mapping(url, source, "remote_archive_image", manifest_rows, replacements, redirects)
    next
  end

  content_type = head_content_type(url)
  if content_type&.start_with?("image/")
    basename = remote_download_basename(url, content_type)
    target_path = unique_destination_for(basename)
    download_remote_image(url, target_path)
    optimization = optimize_image(target_path)
    target_url = "/assets/squarespace/#{File.basename(target_path)}"
    replacements[url] = target_url
    manifest_rows << ["remote_downloaded_image", url, url, target_url, optimization]
  elsif url == PAPERLESS_WORKFLOW_URL
    basename = "paperless-workflow-enlarged.jpg"
    target_path = File.join(TARGET_DIR, basename)
    download_remote_image(url, target_path)
    optimization = optimize_image(target_path)
    target_url = "/assets/squarespace/#{basename}"
    replacements[url] = target_url
    manifest_rows << ["remote_downloaded_image", url, url, target_url, optimization]
  else
    manifest_rows << ["remote_left_external", url, "", "", content_type.to_s]
  end
end

# Clean up a migrated PBIS duplicate that already existed with a broken /assets-less path.
replacements["{{ site.url }}/PBIS+as+medicine.ppt"] = "/assets/PBIS+as+medicine.ppt"
replacements["{{ site.url }}/assets/PBIS+as+medicine.key"] = "/assets/PBIS+as+medicine.key"

markdown_files.each do |file|
  original = File.read(file)
  updated = original.dup
  replacements.sort_by { |old_ref, _new_ref| -old_ref.length }.each do |old_ref, new_ref|
    updated.gsub!(old_ref, new_ref)
  end
  File.write(file, updated) if updated != original
end

tsv_escape = ->(value) { value.to_s.gsub("\t", " ").gsub("\r", " ").gsub("\n", " ") }
manifest_lines = [%w[action old_reference source new_reference note].join("\t")]
manifest_rows.sort_by { |row| [row[0], row[1]] }.each do |row|
  manifest_lines << row.map { |value| tsv_escape.call(value) }.join("\t")
end
File.write(MANIFEST_PATH, "#{manifest_lines.join("\n")}\n")

redirect_block = [
  "# BEGIN Squarespace image redirects",
  *redirects.sort.map { |old_ref, target| "#{old_ref} #{target} 301!" },
  "# END Squarespace image redirects"
].join("\n")

redirects_text = File.read(REDIRECTS_PATH)
redirects_text = redirects_text.gsub(/\n?# BEGIN Squarespace image redirects\n.*?\n# END Squarespace image redirects\n?/m, "\n")
domain_rule_index = redirects_text.index(/^https:\/\/www\.jethrojones\.com\/\*/m) || redirects_text.length
before = redirects_text[0...domain_rule_index].rstrip
after = redirects_text[domain_rule_index..]&.lstrip || ""
File.write(REDIRECTS_PATH, "#{before}\n\n#{redirect_block}\n\n#{after}")

puts "Mapped #{replacements.size} references."
puts "Copied assets to #{TARGET_DIR}."
puts "Wrote manifest to #{MANIFEST_PATH}."
puts "Added #{redirects.size} image redirects."
