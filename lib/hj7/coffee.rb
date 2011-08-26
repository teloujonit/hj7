require 'coffee-script'

module HJ7::Coffee
  class CoffeeConverter < Converter
    safe true
    priority :normal

    def matches(ext)
      ext =~ /coffee/i
    end

    def output_ext(ext)
      '.js'
    end

    def convert(content)
      begin
        CoffeeScript.compile content
      rescue StandardError => e
        puts 'CoffeeScript error:' + e.message
      end
    end
  end
end