require 'jekyll'

module HJ7::Notifier
  APPLICATION_NAME = 'Jekyll'

  def self.turn_off
    ENV['JEKYLL_NOTIFY'] = 'false'
  end

  def self.turn_on
    ENV['JEKYLL_NOTIFY'] = 'true'

    case RbConfig::CONFIG['target_os']
    when /darwin/i
      require_growl
    when /linux/i
      require_libnotify
    when /mswin|mingw/i
      require_rbnotifu
    end
  end

  def self.notify(message, options = {})
    if enabled?
      image = options.delete(:image) || File.expand_path('assets/images/logo_square.png')
      title = options.delete(:title) || 'Jekyll'

      case RbConfig::CONFIG['target_os']
      when /darwin/i
        notify_mac(title, message, image, options)
      when /linux/i
        notify_linux(title, message, image, options)
      when /mswin|mingw/i
        notify_windows(title, message, image, options)
      end
    end
  end

  def self.enabled?
    ENV['JEKYLL_NOTIFY'] == 'true'
  end

  protected

  def self.notify_mac(title, message, image, options)
    default_options = { title: title, icon: image, name: APPLICATION_NAME }
    default_options.merge!(options)

    if defined?(GrowlNotify)
      default_options[:description] = message
      default_options[:application_name] = APPLICATION_NAME
      default_options.delete(:name)

      GrowlNotify.send_notification(default_options) if enabled?
    else
      Growl.notify message, default_options.merge(options) if enabled?
    end
  end

  def self.notify_linux(title, message, image, options)
    default_options = { body: message, summary: title, icon_path: image, transient: true }
    Libnotify.show default_options.merge(options) if enabled?
  end

  def self.notify_windows(title, message, image, options)
    default_options = { message: message, title: title, type: :info, time: 3 }
    Notifu.show default_options.merge(options) if enabled?
  end

  def self.require_growl
    begin
      require 'growl_notify'

      if GrowlNotify.application_name != APPLICATION_NAME
        GrowlNotify.config do |c|
          c.notifications = c.default_notifications = [ APPLICATION_NAME ]
          c.application_name = c.notifications.first
        end
      end
    rescue LoadError
      require 'growl'
    end
  rescue LoadError
    turn_off
    puts 'Please install growl or growl_notify gem for Mac OS X notification support and add it to your Gemfile'
  end

  def self.require_libnotify
    require 'libnotify'
  rescue LoadError
    turn_off
    puts 'Please install libnotify gem for Linux notification support and add it to your Gemfile'
  end

  def self.require_rbnotifu
    require 'rb-notifu'
  rescue LoadError
    turn_off
    puts 'Please install rb-notifu gem for Windows notification support and add it to your Gemfile'
  end
end
HJ7::Notifier.turn_on

module Jekyll
  class Site
    alias :process_without_growl :process

    def process
      options = {}
      options[:icon] = File.expand_path(config['notifier_logo']) if config['notifier_logo']
      HJ7::Notifier.notify 'Building...', options
      process_without_growl
      HJ7::Notifier.notify 'Build complete', options
    end
  end
end
: