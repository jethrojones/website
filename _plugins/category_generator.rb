module Jekyll
  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      category_groups(site).each do |slug, group|
        site.pages << CategoryPage.new(site, site.source, group[:category], slug, group[:posts])
      end
    end

    private

    def category_groups(site)
      posts = site.posts.docs + site.collections['notes'].docs.select { |doc| doc.data['content_type'] == 'post' }
      posts.each_with_object({}) do |post, groups|
        categories_for(post).each do |category|
          slug = category_slug(category)
          groups[slug] ||= { category: category, posts: [] }
          groups[slug][:posts] << post
        end
      end
    end

    def categories_for(post)
      categories = Array(post.data['categories'])
      categories << post.data['category'] if post.data['category']
      categories.flatten.compact.map(&:to_s).map(&:strip).reject(&:empty?).uniq
    end

    def category_slug(category)
      category.downcase.gsub(' ', '-').gsub(/[^\w-]/, '')
    end
  end

  class CategoryPage < Page
    def initialize(site, base, category, slug, posts)
      @site = site
      @base = base
      @dir  = "categories/#{slug}" # Use the slug for the directory name
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category.html')
      self.data['category'] = category
      self.data['slug'] = slug
      self.data['posts'] = posts
      self.data['title'] = "Category: #{category.capitalize}"
    end
  end
end
