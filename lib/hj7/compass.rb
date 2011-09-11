require 'jekyll'
require 'compass'

module HJ7::Compass
  class CompassConverter < Jekyll::Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /scss/i
    end

    def output_ext(ext)
      '.css'
    end

    def compass
      # compass = ::Compass::Configuration::Data.new('jekyll', @config['compass']).
      #   extend(::Compass::Configuration::Defaults).
      #   extend(::Compass::Configuration::Comments)

      config_file = File.expand_path(@config['compass']['config_file'])
      @_compass ||= ::Compass.add_project_configuration config_file
    end

    def convert(scss)
      begin
        ::Sass::Engine.new(scss, compass.to_sass_engine_options).render
      rescue => e
        puts "Sass Exception: #{e.message}"
        puts "Scss: #{scss}"
      end
    end
  end
end