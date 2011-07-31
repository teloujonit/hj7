require "jekyll"
require "compass"

module HJ7::Compass
  class CompassConverter < Jekyll::Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /scss/i
    end

    def output_ext(ext)
      ".css"
    end

    def convert(scss)
      begin
        compass = Compass::Configuration::Data.new("jekyll", @config["compass"]).
          extend(Compass::Configuration::Defaults).
          extend(Compass::Configuration::Comments)

        options = compass.to_sass_engine_options

        Sass::Engine.new(scss, options).render
      rescue => e
        puts "Sass Exception: #{e.message}"
        puts "Scss: #{scss}"
      end
    end
  end
end

