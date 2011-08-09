module Jekyll

  class TagIndex < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['category'] = category
      self.data['tagdir'] = dir

      tag_title_prefix = site.config['tag_title_prefix'] || 'Tag: '
      self.data['title'] = "#{tag_title_prefix}#{category}"
    end
  end

  class TagGenerator < Generator
    safe true
    
    def generate(site)
      if site.layouts.key? 'tag_index'
        dir = site.config['tag_dir'] || 'tag'
        site.categories.keys.each do |category|
          tag = category.to_s
          write_tag_index(site, File.join(dir, tag_to_dirname(tag)), tag)
        end
      end
    end
  
    def write_tag_index(site, dir, tag)
      index = TagIndex.new(site, site.source, dir, tag)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end

    def tag_to_dirname(tag)
      tag.gsub(/[^[:alnum:]_-]/, '').downcase
    end
  end

end
