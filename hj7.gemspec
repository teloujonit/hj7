# -*- encoding: utf-8 -*-
require File.expand_path("../lib/hj7/version", __FILE__)

Gem::Specification.new do |s|
  s.authors     = ["Louis T."]
  s.email       = ["negonicrac@gmail.com"]
  s.summary     = %q{Jekyll plugins and hacks}
  s.description = %q{Jekyll plugins and hacks}
  s.homepage    = ""

  s.add_dependency "rake"
  s.add_dependency "jekyll"
  s.add_dependency "compass"
  s.add_dependency "jammit"
  s.add_dependency "coffee-script"
  s.add_dependency "jekyll-tagging"
  s.add_dependency "redcarpet", "~> 2.0.0b3"
  s.add_dependency "slim"
  s.add_dependency "albino"

  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.name        = "hj7"
  s.require_paths = ["lib"]
  s.version     = HJ7::VERSION
end
