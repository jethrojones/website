# frozen_string_literal: true

require 'open3'
require 'pathname'
require 'time'

module Recents
  GitDates = Struct.new(:created_at, :updated_at, keyword_init: true)

  class GitFileHistory
    def initialize(source)
      @source = source
      @source_path = Pathname.new(source)
      @cache = {}
      @available = git_available?
    end

    def dates_for(path)
      relative_path = relative_path_for(path)
      return GitDates.new unless @available && relative_path

      @cache[relative_path] ||= begin
        stdout, = Open3.capture3(
          'git',
          '-C',
          @source,
          'log',
          '--follow',
          '--format=%aI',
          '--',
          relative_path
        )
        dates = stdout.lines.map(&:strip).reject(&:empty?)
        GitDates.new(created_at: dates.last, updated_at: dates.first)
      end
    end

    private

    def git_available?
      _, _, status = Open3.capture3('git', '-C', @source, 'rev-parse', '--is-inside-work-tree')
      status.success?
    end

    def relative_path_for(path)
      Pathname.new(path).relative_path_from(@source_path).to_s
    rescue ArgumentError
      nil
    end
  end

  # Generate change information for all markdown pages
  class Generator < Jekyll::Generator
    def generate(site)
      git_history = GitFileHistory.new(site.source)
      items = site.collections['notes'].docs
      items.each do |page|
        front_matter = front_matter_for(page.path)
        front_matter_date = timestamp_from_front_matter(front_matter['date'])
        front_matter_modified_at = timestamp_from_front_matter(front_matter['last_modified_at'])
        filename_date = timestamp_from_filename(page.relative_path)
        git_dates = if front_matter_modified_at && (front_matter_date || filename_date)
                      GitDates.new
                    else
                      git_history.dates_for(page.path)
                    end

        published_at = front_matter_date ||
                       filename_date ||
                       git_dates.created_at ||
                       file_created_at(page.path)
        updated_at = front_matter_modified_at ||
                     git_dates.updated_at ||
                     published_at ||
                     file_modified_at(page.path)

        page.data['date'] = published_at if published_at
        page.data['last_modified_at'] = updated_at if updated_at
        page.data['last_modified_at_timestamp'] = updated_at if updated_at
      end
    end

    def timestamp_from_front_matter(value)
      return nil if value.nil?

      value = value.to_s.strip
      return nil if value.empty?

      Time.parse(value).iso8601
    rescue ArgumentError
      value
    end

    def timestamp_from_filename(relative_path)
      return nil unless relative_path =~ Jekyll::Document::DATE_FILENAME_MATCHER

      timestamp_from_front_matter(Regexp.last_match(1))
    end

    def front_matter_for(path)
      content = File.read(path)
      return {} unless content =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP

      SafeYAML.load(Regexp.last_match(1)) || {}
    rescue Psych::SyntaxError
      {}
    end

    def file_created_at(path)
      File.birthtime(path).iso8601
    rescue NotImplementedError
      file_modified_at(path)
    end

    def file_modified_at(path)
      File.mtime(path).iso8601
    end
  end
end
