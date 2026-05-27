# frozen_string_literal: true

require 'cgi'
require 'rexml/document'
require 'time'
require 'uri'

module Jekyll
  class VideoMetadataGenerator < Generator
    safe true
    priority :low

    def generate(site)
      docs = site.collections.values.flat_map(&:docs) + site.pages

      docs.each do |doc|
        video_url = doc.data['video_url'].to_s.strip
        next if video_url.empty?

        metadata = video_metadata(site, doc, video_url)
        doc.data['video_metadata'] = metadata if metadata
      end

      site.pages << VideoSitemapPage.new(site, site.source, docs)
    end

    private

    def video_metadata(site, doc, video_url)
      embed_url, thumbnail_url = video_urls(site, doc, video_url)
      return nil unless embed_url

      description = doc.data['description'].to_s.strip
      description = doc.data['title'].to_s.strip if description.empty?

      {
        'name' => doc.data['title'].to_s.strip,
        'description' => description,
        'upload_date' => upload_date(doc),
        'embed_url' => embed_url,
        'thumbnail_url' => thumbnail_url
      }.compact
    end

    def video_urls(site, doc, video_url)
      youtube_id = youtube_id(video_url)
      if youtube_id
        return [
          "https://www.youtube.com/embed/#{youtube_id}",
          "https://img.youtube.com/vi/#{youtube_id}/hqdefault.jpg"
        ]
      end

      vimeo_id = video_url[%r{vimeo\.com/(\d+)}, 1]
      return ["https://player.vimeo.com/video/#{vimeo_id}", explicit_thumbnail(site, doc)] if vimeo_id

      loom_id = video_url[%r{loom\.com/share/([^?]+)}, 1]
      return ["https://www.loom.com/embed/#{loom_id}", explicit_thumbnail(site, doc)] if loom_id

      if video_url.include?('share.transistor.fm')
        return [video_url.sub('/s/', '/e/'), explicit_thumbnail(site, doc)]
      end

      [nil, explicit_thumbnail(site, doc)]
    end

    def youtube_id(video_url)
      return Regexp.last_match(1) if video_url =~ %r{youtu\.be/([^?&/]+)}
      return Regexp.last_match(1) if video_url =~ %r{youtube\.com/shorts/([^?&/]+)}
      return CGI.parse(URI.parse(video_url).query.to_s)['v']&.first if video_url.include?('youtube.com/watch')

      nil
    rescue URI::InvalidURIError
      nil
    end

    def explicit_thumbnail(site, doc)
      thumbnail = doc.data['video_thumbnail'].to_s.strip
      thumbnail = doc.data['image'].to_s.strip if thumbnail.empty?
      absolute_url(site, thumbnail) unless thumbnail.empty?
    end

    def absolute_url(site, value)
      return value if value.start_with?('http://', 'https://')

      "#{site.config['url']}#{value.start_with?('/') ? value : "/#{value}"}"
    end

    def upload_date(doc)
      date = doc.data['date'] || doc.data['last_modified_at'] || Time.now
      Time.parse(date.to_s).strftime('%Y-%m-%d')
    rescue ArgumentError
      Time.now.strftime('%Y-%m-%d')
    end
  end

  class VideoSitemapPage < PageWithoutAFile
    def initialize(site, base, docs)
      @site = site
      @base = base
      @dir = ''
      @name = 'video-sitemap.xml'

      process(@name)
      self.data = { 'layout' => nil, 'sitemap' => false }
      self.content = build_xml(site, docs)
    end

    private

    def build_xml(site, docs)
      xml = +"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
      xml << "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\" xmlns:video=\"http://www.google.com/schemas/sitemap-video/1.1\">\n"

      docs.each do |doc|
        metadata = doc.data['video_metadata']
        next unless sitemap_video?(metadata)

        xml << "  <url>\n"
        xml << "    <loc>#{escape(site.config['url'] + doc.url)}</loc>\n"
        xml << "    <video:video>\n"
        xml << "      <video:thumbnail_loc>#{escape(metadata['thumbnail_url'])}</video:thumbnail_loc>\n"
        xml << "      <video:title>#{escape(metadata['name'])}</video:title>\n"
        xml << "      <video:description>#{escape(metadata['description'])}</video:description>\n"
        xml << "      <video:player_loc>#{escape(metadata['embed_url'])}</video:player_loc>\n"
        xml << "      <video:publication_date>#{escape(metadata['upload_date'])}</video:publication_date>\n"
        xml << "    </video:video>\n"
        xml << "  </url>\n"
      end

      xml << "</urlset>\n"
      xml
    end

    def sitemap_video?(metadata)
      metadata &&
        metadata['name'].to_s.strip != '' &&
        metadata['description'].to_s.strip != '' &&
        metadata['thumbnail_url'].to_s.strip != '' &&
        metadata['embed_url'].to_s.strip != ''
    end

    def escape(value)
      REXML::Text.new(value.to_s, false, nil, false).to_s
    end
  end
end
