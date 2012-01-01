require "jekyll"
require "redcarpet"
require "albino"

module HJ7::RedcarpetConverter
end

class HTMLwithPygments < Redcarpet::Render::HTML
  def block_code(code, language)
    Albino.colorize(code, language)
  end
end

module Jekyll
  class MarkdownConverter < Converter
    def markdown
      @_markdown ||= ::Redcarpet::Markdown.new(
        HTMLwithPygments, autolink: true, fenced_code_blocks: true,
        strikethrough: true, superscript: true, no_intra_emphasis: true,
        tables:true)
    end

    def convert(content)
      markdown.render(content)
    end
  end
end
