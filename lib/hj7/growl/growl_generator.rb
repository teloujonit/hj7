require "growl"
require "jekyll"

module HJ7::Growl
  class GrowlGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
    end
  end
end

module Jekyll
  class Site
    alias :process_without_growl :process

    def process
      icon = File.expand_path("images/logo_square.png")
      Growl.notify "Building...", :title => "Jekyll", :icon => icon
      process_without_growl
      Growl.notify "Build complete", :title => "Jekyll", :icon => icon
    end
  end
end
