module Jekyll
  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      site.categories.each do |category, posts|
        # Generate slug for the category
        slug = category.downcase.gsub(' ', '-').gsub(/[^\w-]/, '')

        # Capitalize the first letter for display purposes
        display_name = category.split.map(&:capitalize).join(' ')

        # Debugging: Output the category and its generated slug
        puts "Generating category '#{category}' with slug '#{slug}'"

        # Create a new category page
        site.pages << CategoryPage.new(site, site.source, display_name, slug, posts)
      end
    end
  end

  class CategoryPage < Page
    def initialize(site, base, display_name, slug, posts)
      @site = site
      @base = base
      @dir  = "categories/#{slug}" # Use the slug for the directory name
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category.html')
      self.data['category'] = display_name
      self.data['slug'] = slug
      self.data['posts'] = posts
      self.data['title'] = "Category: #{display_name}"

      # Create RSS feed
      create_feed_page(site, base, display_name, slug, posts)
    end

    def create_feed_page(site, base, display_name, slug, posts)
      feed = Page.new(site, base, "categories/#{slug}", "feed.xml")
      feed.process("feed.xml")
      
      # Read and set content for the RSS feed
      feed.content = File.read(File.join(base, "_feed_category.xml"))
      feed.data['category'] = display_name
      feed.data['slug'] = slug
      feed.data['posts'] = posts

      # Add to site pages
      site.pages << feed
    end
  end
end