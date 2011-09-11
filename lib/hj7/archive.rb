module HJ7::Archive
  class ArchivePage < Jekyll::Page
    def initialize(site, base, dir, name, data = {})
      self.content = data.delete('content') || ''
      self.data    = data

      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing
    end
  end

  class ArchiveGenerator < Jekyll::Generator
    safe true

    def generate(site)
      if site.config['archive']
        @layouts = {}

        @layouts[:yearly]  = site.config['archive']['yearly_page_layout']
        @layouts[:monthly] = site.config['archive']['monthly_page_layout']
        @layouts[:daily]   = site.config['archive']['daily_page_layout']

        generate_yearly_archive_pages(site) if @layouts[:yearly]
        generate_monthly_archive_pages(site) if @layouts[:monthly]
        generate_daily_archive_pages(site) if @layouts[:daily]
      end
    end

    protected

    def generate_yearly_archive_pages(site)
      collate_posts(site.posts, '%Y').each {|key, posts|
        puts "Generating year archive for #{key}"
        site.pages << new_yearly_page(site, key, posts.sort.reverse)
      }
    end

    def new_yearly_page(site, key, posts)
      year = key

      ArchivePage.new(site, site.source, '/', "#{year}.html", {
        'layout' => @layouts[:yearly],
        'year'   => year,
        'posts'  => posts
      })
    end

    def generate_monthly_archive_pages(site)
      collate_posts(site.posts, '%Y/%m').each do |key, posts|
        puts "Generating monthly archive for #{key}"
        site.pages << new_monthly_page(site, key, posts.sort.reverse)
      end
    end

    def new_monthly_page(site, key, posts)
      year, month = key.split('/')

      ArchivePage.new(site, site.source, "#{year}/", "#{month}.html", {
        'layout' => @layouts[:monthly],
        'year'   => year,
        'month'  => month,
        'posts'  => posts
      })
    end

    def generate_daily_archive_pages(site)
      collate_posts(site.posts, '%Y/%m/%d').each {|key, posts|
        puts "Generating daily archive for #{key}"
        site.pages << new_daily_page(site, key, posts.sort.reverse)
      }
    end

    def new_daily_page(site, key, posts)
      year, month, day = key.split('/')

      ArchivePage.new(site, site.source, "#{year}/#{month}", "#{day}.html", {
        'layout' => @layouts[:daily],
        'year'   => year,
        'month'  => month,
        'day'    => day,
        'posts'  => posts
      })
    end

    def collate_posts(posts, strftime)
      collated = {}
      posts.each do |post|
        key = post.date.strftime(strftime)
        if collated.has_key? key
          collated[key] << post
        else
          collated[key] = [post]
        end
      end
      collated
    end
  end
end
