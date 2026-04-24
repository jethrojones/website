#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'json'
require 'open3'
require 'optparse'
require 'time'
require 'yaml'

class PostsToNotesMigrator
  POST_NAME_PATTERN = /\A(\d{4})-(\d{2})-(\d{2})-(.+)\.(md|html)\z/i
  INTERNAL_PATH_PATTERN = %r{\A/}

  attr_reader :root, :reports_dir, :apply

  def initialize(root:, reports_dir:, apply:)
    @root = File.expand_path(root)
    @reports_dir = File.expand_path(reports_dir, @root)
    @apply = apply
    @warnings = []
    @entries = []
  end

  def run
    FileUtils.mkdir_p(reports_dir)
    collect_entries
    assign_destinations
    write_pre_manifest
    write_report
    apply_changes if apply
    write_post_manifest if apply
    write_rollback_note if apply
    print_summary
  end

  private

  def collect_entries
    post_files.each do |absolute_path|
      source_path = relative_path(absolute_path)
      basename = File.basename(source_path)
      match = basename.match(POST_NAME_PATTERN)

      unless match
        warn_for(source_path, 'Skipped because filename does not match Jekyll post date pattern.')
        next
      end

      year, month, day, slug, extension = match.captures
      front_matter, body, parse_warnings = read_document(absolute_path)
      parse_warnings.each { |message| warn_for(source_path, message) }

      canonical_url = "/#{year}/#{month}/#{day}/#{slug}/"
      title = present_string(front_matter['title']) || title_from_slug(slug)
      date = present_string(front_matter['date']) || "#{year}-#{month}-#{day}"
      destination_path = "_notes/posts/#{year}-#{month}-#{day}-#{slug}.md"
      source_permalink = normalize_internal_path(front_matter['permalink'])
      redirect_from = redirect_aliases(
        canonical_url: canonical_url,
        source_permalink: source_permalink,
        existing_redirects: front_matter['redirect_from']
      )

      @entries << {
        'source_path' => source_path,
        'source_extension' => ".#{extension.downcase}",
        'old_url' => canonical_url,
        'title' => title,
        'date' => date.to_s,
        'layout' => present_string(front_matter['layout']),
        'destination_path' => destination_path,
        'canonical' => true,
        'redirect_from' => redirect_from,
        'front_matter' => front_matter,
        'body' => body
      }
    end
  end

  def assign_destinations
    @entries.group_by { |entry| entry['destination_path'] }.each_value do |group|
      next if group.size == 1

      primary = group.find { |entry| entry['source_extension'] == '.md' } || group.first
      group.each do |entry|
        next if entry.equal?(primary)

        entry['canonical'] = false
        entry['destination_path'] = archive_destination_for(entry)
        warn_for(
          entry['source_path'],
          "Duplicate destination for #{primary['source_path']}; migrated as unpublished archive."
        )
      end
    end
  end

  def apply_changes
    @entries.each do |entry|
      destination = File.join(root, entry['destination_path'])
      FileUtils.mkdir_p(File.dirname(destination))
      File.write(destination, render_migrated_document(entry))
      FileUtils.rm_f(File.join(root, entry['source_path']))
    end
  end

  def render_migrated_document(entry)
    data = normalized_front_matter(entry)
    body = migrated_body(entry)
    "#{YAML.dump(data)}---\n#{body}"
  end

  def normalized_front_matter(entry)
    data = stringify_keys(entry['front_matter'])
    data.delete('redirect_to')
    data['layout'] = 'note'
    data['content_type'] = entry['canonical'] ? 'post' : 'post_archive'
    data['title'] = entry['title']
    data['date'] = entry['date']
    data['original_post_path'] = entry['source_path']

    if entry['canonical']
      data['permalink'] = entry['old_url']
      data['redirect_from'] = entry['redirect_from'] if entry['redirect_from'].any?
    else
      data.delete('permalink')
      data.delete('redirect_from')
      data['published'] = false
      data['sitemap'] = false
    end

    data
  end

  def migrated_body(entry)
    body = entry['body'].to_s
    return ensure_trailing_newline(body) unless entry['source_extension'] == '.html'

    markdown, warning = html_to_markdown(body)
    warn_for(entry['source_path'], warning) if warning
    ensure_trailing_newline(markdown)
  end

  def html_to_markdown(html)
    stdout, stderr, status = Open3.capture3('pandoc', '--from=html', '--to=gfm', stdin_data: html)
    return [stdout.strip, nil] if status.success?

    [html, "pandoc failed while converting HTML; kept original body. #{stderr.strip}"]
  rescue Errno::ENOENT
    [html, 'pandoc is not installed; kept original HTML body.']
  end

  def write_pre_manifest
    write_json('pre-migration-url-manifest.json', manifest_entries)
  end

  def write_post_manifest
    write_json('post-migration-url-manifest.json', manifest_entries)
  end

  def write_json(filename, payload)
    File.write(File.join(reports_dir, filename), "#{JSON.pretty_generate(payload)}\n")
  end

  def write_report
    lines = []
    lines << '# Posts To Notes Migration Report'
    lines << ''
    lines << "Mode: #{apply ? 'apply' : 'dry-run'}"
    lines << "Posts found: #{@entries.size}"
    lines << "Canonical posts: #{@entries.count { |entry| entry['canonical'] }}"
    lines << "Archived duplicates: #{@entries.count { |entry| !entry['canonical'] }}"
    lines << "Redirect aliases: #{@entries.sum { |entry| entry['redirect_from'].size }}"
    lines << ''
    lines << '## Warnings'
    lines << ''
    if @warnings.empty?
      lines << 'No warnings.'
    else
      @warnings.each { |warning| lines << "- #{warning}" }
    end
    lines << ''
    lines << '## Duplicate Groups'
    lines << ''
    duplicate_groups = @entries.group_by { |entry| entry['old_url'] }.select { |_url, group| group.size > 1 }
    if duplicate_groups.empty?
      lines << 'No duplicate old URLs.'
    else
      duplicate_groups.each do |url, group|
        lines << "- #{url}: #{group.map { |entry| entry['source_path'] }.join(', ')}"
      end
    end
    lines << ''
    File.write(File.join(reports_dir, 'migration-report.md'), "#{lines.join("\n")}\n")
  end

  def write_rollback_note
    content = <<~MARKDOWN
      # Roll Back Posts To Notes Migration

      The migration is intended to be committed as one isolated commit after verification.

      To roll it back after that commit exists:

      ```bash
      git revert <migration-commit>
      bundle exec jekyll build --disable-disk-cache
      bash script/check-redirects-for-renamed-urls.sh HEAD^
      ```

      Replace `<migration-commit>` with the commit hash for the posts-to-notes migration commit.
    MARKDOWN

    File.write(File.join(reports_dir, 'rollback.md'), content)
  end

  def manifest_entries
    @entries.map do |entry|
      {
        'source_path' => entry['source_path'],
        'source_extension' => entry['source_extension'],
        'old_url' => entry['old_url'],
        'title' => entry['title'],
        'date' => entry['date'],
        'layout' => entry['layout'],
        'destination_path' => entry['destination_path'],
        'canonical' => entry['canonical'],
        'redirect_from' => entry['redirect_from']
      }
    end
  end

  def post_files
    Dir[File.join(root, '_posts', '*')].select do |path|
      File.file?(path) && ['.md', '.html'].include?(File.extname(path).downcase)
    end.sort
  end

  def read_document(path)
    raw = File.read(path)
    return [{}, raw, ['No YAML front matter found.']] unless raw.start_with?("---\n")

    lines = raw.lines
    front_matter_lines = []
    body = nil

    lines[1..]&.each_with_index do |line, index|
      if line.start_with?('---')
        suffix = line.sub(/\A---\s?/, '')
        remaining_lines = lines[(index + 2)..] || []
        body = "#{suffix}#{remaining_lines.join}"
        break
      end
      front_matter_lines << line
    end

    return [{}, raw, ['YAML front matter was opened but not closed.']] if body.nil?

    parsed = YAML.safe_load(
      front_matter_lines.join,
      permitted_classes: [Date, Time],
      aliases: true
    ) || {}

    [parsed, body, []]
  rescue Psych::Exception => e
    [fallback_front_matter(front_matter_lines.join), body || raw, ["YAML parse failed; used fallback parser. #{e.message.lines.first&.strip}"]]
  end

  def fallback_front_matter(front_matter)
    front_matter.each_line.each_with_object({}) do |line, data|
      next unless line.match?(/\A[a-zA-Z0-9_-]+:/)

      key, value = line.split(':', 2)
      data[key] = value.to_s.strip
    end
  end

  def redirect_aliases(canonical_url:, source_permalink:, existing_redirects:)
    aliases = []
    aliases << source_permalink if source_permalink && source_permalink != canonical_url
    Array(existing_redirects).each do |redirect|
      normalized = normalize_internal_path(redirect)
      aliases << normalized if normalized && normalized != canonical_url
    end
    aliases.uniq
  end

  def normalize_internal_path(value)
    path = present_string(value)
    return nil unless path
    return nil if path.include?('://')
    return nil unless path.match?(INTERNAL_PATH_PATTERN)

    path
  end

  def present_string(value)
    return nil if value.nil?

    text = value.to_s.strip
    text.empty? ? nil : text
  end

  def title_from_slug(slug)
    slug.tr('-', ' ').split.map(&:capitalize).join(' ')
  end

  def archive_destination_for(entry)
    basename = File.basename(entry['destination_path'], '.md')
    "_notes/posts/_archive/#{basename}-from#{entry['source_extension'].delete('.')}.md"
  end

  def stringify_keys(hash)
    hash.each_with_object({}) { |(key, value), result| result[key.to_s] = value }
  end

  def ensure_trailing_newline(text)
    stripped = text.to_s.rstrip
    stripped.empty? ? "\n" : "#{stripped}\n"
  end

  def warn_for(path, message)
    @warnings << "#{path}: #{message}"
  end

  def relative_path(path)
    path.delete_prefix("#{root}/")
  end

  def print_summary
    puts "#{apply ? 'Applied' : 'Dry-run complete'}: #{@entries.size} posts inventoried."
    puts "Reports written to #{reports_dir}."
  end
end

options = {
  root: Dir.pwd,
  reports_dir: 'docs/migrations/posts-to-notes',
  apply: nil
}

OptionParser.new do |parser|
  parser.banner = 'Usage: migrate-posts-to-notes.rb [--dry-run|--apply] [--root PATH] [--reports-dir PATH]'

  parser.on('--root PATH', 'Repository root to migrate') { |value| options[:root] = value }
  parser.on('--reports-dir PATH', 'Directory where manifests and reports are written') { |value| options[:reports_dir] = value }
  parser.on('--dry-run', 'Write reports without moving files') { options[:apply] = false }
  parser.on('--apply', 'Move and convert posts') { options[:apply] = true }
end.parse!

if options[:apply].nil?
  warn 'Choose exactly one mode: --dry-run or --apply.'
  exit 2
end

PostsToNotesMigrator.new(
  root: options[:root],
  reports_dir: options[:reports_dir],
  apply: options[:apply]
).run
