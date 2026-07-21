# frozen_string_literal: true

require "cgi"

module JethroSite
  module SocialImage
    IMAGE_SOURCE = /<img\b[^>]*\b(?:src|data-src)\s*=\s*(?:"([^"]+)"|'([^']+)'|([^\s>]+))/im

    module_function

    def apply(item, fallback)
      return unless item.data["image"].to_s.strip.empty?

      image = first_image(item.content) || fallback
      item.data["image"] = normalize(image) unless image.to_s.strip.empty?
    end

    def first_image(html)
      match = html.to_s.match(IMAGE_SOURCE)
      CGI.unescape_html(match&.captures&.compact&.first.to_s).strip.then { |source| source unless source.empty? }
    end

    def normalize(source)
      image = source.to_s.strip
      return image if image.empty? || image.match?(%r{\A(?:[a-z][a-z0-9+.-]*:|//)}i)

      image = image.sub(/\A\{\{\s*site\.(?:url|baseurl)\s*\}\}/, "")
      image.start_with?("/") ? image : "/#{image}"
    end
  end
end

if defined?(Jekyll::Hooks)
  %i[pages documents].each do |owner|
    Jekyll::Hooks.register owner, :post_convert do |item|
      JethroSite::SocialImage.apply(item, item.site.config["default_social_image"])
    end
  end
end

# Created by Codex GPT-5.6 on 2026-07-21 12:07 PT on Jethro-MBP
