require 'jekyll'
require 'jammit'

module HJ7::Jammit
  class JammitGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
    end
  end
end

module Jekyll
  class Site
    alias :process_without_jammit :process

    def process
      process_without_jammit
      if Jekyll::ENV == 'production'
        puts 'jammit!!'
        system 'jammit -o _site/assets -c _assets.yml'
      end
    end
  end
end
