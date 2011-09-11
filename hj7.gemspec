# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'hj7/version'

Gem::Specification.new do |s|
  s.name        = 'hj7'
  s.version     = HJ7::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Louis T.']
  s.email       = ['negonicrac@gmail.com']
  s.homepage    = ''
  s.summary     = %q{Jekyll plugins and hacks}
  s.description = %q{Jekyll plugins and hacks}

  s.rubyforge_project = 'hj7'

  s.add_dependency 'rake'
  s.add_dependency 'jekyll'
  s.add_dependency 'growl'
  s.add_dependency 'compass'
  s.add_dependency 'jammit'
  s.add_dependency 'coffee-script'
  s.add_dependency 'jekyll-tagging'

  s.files         = `git ls-files`.split('\n')
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split('\n')
  s.executables   = `git ls-files -- bin/*`.split('\n').map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
