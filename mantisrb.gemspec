# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mantisrb/version"

Gem::Specification.new do |s|
  s.name        = "mantisrb"
  s.version     = Mantisrb::VERSION
  s.authors     = ["Nick Klauer"]
  s.email       = ["klauer@gmail.com"]
  s.homepage    = "http://github.com/klauern/mantisrb"
  s.summary     = %q{Mantis BT utility for working with Mantis through the Mantis Connect(http://www.futureware.biz/mantisconnect/) SOAP API.  yeah, SOAP...not my call}
  s.description = %q{This utility provides a Ruby interface for working with a remote Mantis (http://www.mantisbt.org) issue tracker through the Mantis Connect SOAP API.}

  s.rubyforge_project = "mantisrb"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "bundler"
  s.add_runtime_dependency "builder", "~> 2.1.2"
  s.add_runtime_dependency "savon"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "log4r"
  s.add_development_dependency "minitest", ">= 2.5.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "guard"
  s.add_development_dependency "rb-fchange"
  s.add_development_dependency "rb-notifu"
  s.add_development_dependency "guard-minitest"
  s.add_development_dependency "guard-rake"
  s.add_development_dependency "growl"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "yard"
  s.add_development_dependency "rdiscount"
  s.add_development_dependency "pry", ">= 0.9.5"
  s.add_development_dependency "simplecov", '>= 0.5.2'
  s.add_development_dependency "savon_spec"
  s.add_development_dependency "mocha"

end
