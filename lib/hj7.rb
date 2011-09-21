require 'bundler/setup'
require 'jekyll'

module HJ7
end

module Jekyll
  class Site
    def site_payload
      {"site" => self.config.merge({
          "time"       => self.time,
          "posts"      => self.posts.sort { |a, b| b <=> a },
          "pages"      => self.pages,
          "html_pages" => self.pages.reject { |page| !page.html? },
          "categories" => post_attr_hash('categories'),
          "tags"       => post_attr_hash('tags'),
          "environment"=> (Jekyll::ENV || 'development').to_s})}
    end
  end
end