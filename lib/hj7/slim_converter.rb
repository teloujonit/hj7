require 'jekyll'
require 'slim'

module HJ7::Slim
  class SlimConverter < Jekyll::Converter
    safe true
    priority :normal

    def matches(ext)
      ext =~ /slim/i
    end

    def output_ext(ext)
      '.html'
    end

    def convert(content)
      begin
        Slim::Template.new({}) { content }.render
      rescue StandardError => e
        puts 'Slim error:' + e.message
      end
    end
  end
end