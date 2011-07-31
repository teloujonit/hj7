module HJ7::Tagging
end

require "jekyll/tagging"

module Jekyll
  module Filters
    def tag_url(tag, dir = "tags")
      "/#{dir}/#{ERB::Util.u(tag)}"
    end

    def tags(obj)
      tags = obj["tags"][0].is_a?(Array) ? obj["tags"].map{ |t| t[0]} : obj["tags"]
      tags.map { |t| tag_link(t, tag_url(t)) if t.is_a?(String) }.compact.join(" ")
    end

    def ordinal(num)
      num = num.to_i
      case num % 100
        when 11..13; "#{num}th"
      else
        case num % 10
          when 1; "#{num}st"
          when 2; "#{num}nd"
          when 3; "#{num}rd"
          else    "#{num}th"
        end
      end
    end

    def month_name(month_number)
      month_number = month_number.to_i
      Date::MONTHNAMES[month_number]
    end
  end
end
