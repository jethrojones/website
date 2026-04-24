module Jekyll
  class LegacyBlogPaginationRedirect < PageWithoutAFile
    def initialize(site, base, page_num)
      @site = site
      @base = base
      @dir = "blog/page#{page_num}"
      @name = 'index.html'

      process(@name)
      self.data = {}
      self.data['layout'] = nil
      self.data['sitemap'] = false
      self.data['title'] = "Blog page #{page_num}"
      self.content = <<~HTML
        <!doctype html>
        <html lang="en">
          <head>
            <meta charset="utf-8">
            <meta http-equiv="refresh" content="0; url=/blog/">
            <link rel="canonical" href="/blog/">
            <title>Redirecting to Blog</title>
          </head>
          <body>
            <p>Redirecting to <a href="/blog/">the blog archive</a>.</p>
          </body>
        </html>
      HTML
    end
  end

  class LegacyBlogPaginationRedirectGenerator < Generator
    safe true

    def generate(site)
      page_count = site.config['legacy_blog_paginated_pages'].to_i
      return if page_count < 2

      (2..page_count).each do |page_num|
        site.pages << LegacyBlogPaginationRedirect.new(site, site.source, page_num)
      end
    end
  end
end
