module Jekyll
  class Site
    alias :process_without_tidy :process

    def process
      process_without_tidy
      if config.has_key?("tidy") and config["tidy"].has_key?("config_file")
        config_file = config["tidy"]["config_file"]
        if File.exists?(config_file)
          puts "tidy!!"
          system "find _site -name \"*.html\" -exec tidy -config #{config_file} {} \;"
        end
      end
    end
  end
end