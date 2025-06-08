module Jekyll
  class NotesPaginatedIndex < Page
    def initialize(site, base, dir, index, notes, page_num, total_pages, paginate_path)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'

      process(@name)
      self.content = index.content
      self.data = index.data.dup
      self.data['paginated_notes'] = notes
      self.data['notes_paginator'] = {
        'current_page' => page_num,
        'total_pages' => total_pages,
        'previous_page_path' => page_num > 1 ? (page_num - 1 == 1 ? '/' : paginate_path.sub(':num', (page_num - 1).to_s)) : nil,
        'next_page_path' => page_num < total_pages ? paginate_path.sub(':num', (page_num + 1).to_s) : nil
      }
    end
  end

  class NotesPaginationGenerator < Generator
    safe true
    priority :low

    def generate(site)
      index = site.pages.find { |p| p.url == '/' && p.name =~ /^index\.(md|html)$/ }
      return unless index

      notes = site.collections['notes'].docs.sort_by { |n| n.data['last_modified_at_timestamp'] || n.data['date'] }.reverse
      per_page = site.config['notes_per_page'] || 10
      paginate_path = site.config['notes_paginate_path'] || '/page:num/'
      total_pages = (notes.size.to_f / per_page).ceil

      (1..total_pages).each do |num|
        dir = num == 1 ? '' : paginate_path.sub(':num', num.to_s).sub(%r!^/!, '')
        paginated_notes = notes.slice((num - 1) * per_page, per_page) || []
        site.pages << NotesPaginatedIndex.new(site, site.source, dir, index, paginated_notes, num, total_pages, paginate_path)
      end

      site.pages.delete(index)
    end
  end
end
