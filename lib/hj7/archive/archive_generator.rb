require "jekyll"

module HJ7::Archive
  class ArchiveGenerator < Jekyll::Generator
    safe true

    def generate(site)
      @layouts = {}

      @layouts[:yearly]  = site.config["archive"]["yearly_page_layout"]
      @layouts[:monthly] = site.config["archive"]["monthly_page_layout"]
      @layouts[:daily]   = site.config["archive"]["daily_page_layout"]

      generate_yearly_archive_pages(site) if @layouts[:yearly]
      generate_monthly_archive_pages(site) if @layouts[:monthly]
      generate_daily_archive_pages(site) if @layouts[:daily]
    end

    def generate_yearly_archive_pages(site)
      collate_by_year(site.posts).each {|key, posts|
        puts "Generating year archive for #{key}"
        site.pages << new_yearly_page(site, key, posts.sort.reverse)
      }
    end
    private :generate_yearly_archive_pages

    def new_yearly_page(site, key, posts)
      year = key

      ArchivePage.new(site, site.source, "/", "#{year}.html", {
        "layout" => @layouts[:yearly],
        "year" => year,
        "posts" => posts
      })
    end
    private :new_yearly_page

    def generate_monthly_archive_pages(site)
      collate_by_month(site.posts).each do |key, posts|
        puts "Generating monthly archive for #{key}"
        site.pages << new_monthly_page(site, key, posts.sort.reverse)
      end
    end
    private :generate_monthly_archive_pages

    def new_monthly_page(site, key, posts)
      year, month = key.split("/")

      ArchivePage.new(site, site.source, "#{year}/", "#{month}.html", {
        "layout" => @layouts[:monthly],
        "year" => year,
        "month" => month,
        "posts" => posts
      })
    end
    private :new_monthly_page

    def generate_daily_archive_pages(site)
      collate_by_day(site.posts).each {|key, posts|
        puts "Generating daily archive for #{key}"
        site.pages << new_daily_page(site, key, posts.sort.reverse)
      }
    end
    private :generate_daily_archive_pages

    def new_daily_page(site, key, posts)
      year, month, day = key.split("/")

      ArchivePage.new(site, site.source, "#{year}/#{month}", "#{day}.html", {
        "layout" => @layouts[:daily],
        "year" => year,
        "month" => month,
        "day" => day,
        "posts" => posts
      })
    end
    private :new_daily_page

    def collate_by_year(posts)
      collated = {}
      posts.each do |post|
        key = post.date.strftime("%Y")
        if collated.has_key? key
          collated[key] << post
        else
          collated[key] = [post]
        end
      end
      collated
    end
    private :collate_by_year

    def collate_by_month(posts)
      collated = {}
      posts.each do |post|
        key = post.date.strftime("%Y/%m")
        if collated.has_key? key
          collated[key] << post
        else
          collated[key] = [post]
        end
      end
      collated
    end
    private :collate_by_month


    def collate_by_day(posts)
      collated = {}
      posts.each do |post|
        key = post.date.strftime("%Y/%m/%d")
        if collated.has_key? key
          collated[key] << post
        else
          collated[key] = [post]
        end
      end
      collated
    end
    private :collate_by_day
  end
end
