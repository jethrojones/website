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
    end
  end
end
