require 'bundler/setup'
require 'liquid'
require 'jekyll'

module HJ7
  class SiteEnvironment < Liquid::Tag
    def render(context)
      (ENV['JEKYLL_ENV'] || 'development').to_s
    end
  end

  Liquid::Template.register_tag('site_environment', SiteEnvironment)
end