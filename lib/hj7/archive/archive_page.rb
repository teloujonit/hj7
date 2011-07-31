require "jekyll"

module HJ7::Archive
  class ArchivePage < Jekyll::Page
    def initialize(site, base, dir, name, data = {})
      self.content = data.delete("content") || ""
      self.data    = data

      super(site, base, dir, name)
    end

    def read_yaml(_, __)
      # Do nothing
    end
  end
end
