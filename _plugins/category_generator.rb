module Jekyll
  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      site.categories.each do |category, posts|
        # Generate slug for the category
        slug = category.downcase.gsub(' ', '-').gsub(/[^\w-]/, '')

        # Debugging: Output the category and its generated slug
        puts "Generating category '#{category}' with slug '#{slug}'"

        # Create a new category page
        site.pages << CategoryPage.new(site, site.source, category, slug, posts)
      end
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
        # RSS feed
      create_feed_page(site, base, display_name, slug, docs)
  	end

  	def create_feed_page(site, base, display_name, slug, docs)
    feed = Page.new(site, base, "categories/#{slug}", "feed.xml")
    feed.process("feed.xml")
    feed.content = File.read(File.join(base, "_feed_category.xml"))
    feed.data['category'] = display_name.downcase
    site.pages << feed
 	end
    end
  end
end
