require "jekyll"
require "jammit"

module Jekyll
  class Site
    alias :process_without_jammit :process

    def process
      process_without_jammit
      if Jekyll::ENV == "production"
        if config.has_key?("jammit") and config["tidy"].has_key?("config_file")
          config_file = config["jammit"]["config_file"]

          if config["tidy"].has_key?("asset_dir")
            asset_dir = config["jammit"]["asset_dir"]
          else
            asset_dir = "assets"
          end

          if File.exists?(config_file)
            puts "jammit!!"
            system "jammit -o _site/#{asset_dir} -c #{config_file}"
          end
        end
      end
    end
  end
end

module HJ7::Jammit
  module Tags
    class AssetTag < Liquid::Tag
      def initialize(tag_name, name, kind, tokens)
        super tag_name, name, tokens
        @name   = name.to_s.strip
        @kind   = kind.to_s
        @config = File.exists?("_assets.yml") ? YAML.load_file("_assets.yml") : {}
      end

      def render(context)
        if Jekyll::ENV == "production"
          markup "/assets/#{name_with_ext}"
        else
          (assets_for_name.map do |asset|
            markup "#{@path}/#{asset}"
          end).join("\n")
        end
      end

      protected

      def name_with_ext
        "#{@name}.#{@ext}"
      end

      def assets_for_name
        if @config[@asset_type].include?(@name)
          @config[@asset_type][@name].map do |asset|
            asset.gsub(/_site\/assets\/(stylesheets|javascripts)\//, "")
          end
        else
          name_with_ext
        end
      end
    end

    class IncludeJsTag < AssetTag
      def initialize(tag_name, name, tokens)
        @path = "/assets/javascripts"
        @ext = "js"
        @asset_type = "javascripts"
        super tag_name, name, "js", tokens
      end

      protected

      def markup(src)
        %{<script src="#{src}" type="text/javascript"></script>}.to_s
      end
    end
    Liquid::Template.register_tag("include_js", IncludeJsTag)

    class IncludeCssTag < AssetTag
      def initialize(tag_name, name, tokens)
        @path = "/assets/stylesheets"
        @ext = "css"
        @asset_type = "stylesheets"
        super tag_name, name, "css", tokens
      end

      protected

      def markup(src)
        %{<link href="#{src}" media="screen" rel="stylesheet" type="text/css" />}.to_s
      end
    end
    Liquid::Template.register_tag("include_css", IncludeCssTag)
  end
end
