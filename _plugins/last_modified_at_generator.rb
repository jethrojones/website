# frozen_string_literal: true

require 'fileutils'
require 'pathname'
require 'time'

module Recents
  # Generate change information for all markdown pages
  class Generator < Jekyll::Generator
    def generate(site)
      items = site.collections['notes'].docs
      items.each do |page|
        front_matter_timestamp = timestamp_from_front_matter(page.data['last_modified_at'])
        timestamp = front_matter_timestamp
        timestamp ||= timestamp_from_front_matter(page.data['date'])
        timestamp ||= File.mtime(page.path).iso8601
        page.data['last_modified_at'] = timestamp unless front_matter_timestamp
        page.data['last_modified_at_timestamp'] = timestamp
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
  end
end
