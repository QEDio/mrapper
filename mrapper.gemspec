# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mrapper/version"

Gem::Specification.new do |s|
  s.name        = "mrapper"
  s.version     = Mrapper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Johannes Kaefer"]
  s.email       = ["johannes.kaefer@qed.io"]
  s.homepage    = ""
  s.summary     = %q{Wraps MapReduce-Results}
  s.description = %q{M(ap)R(educe)(w)RAPPER converts the MapReduce-Result from MongoDB (for now) into an ruby object.}

  s.rubyforge_project = "mrapper"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rake'
  s.add_dependency 'bson_ext'
  s.add_dependency 'bzip2-ruby'
  s.add_dependency 'yajl-ruby'

  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'spork'
  s.add_development_dependency 'spork-testunit'
  s.add_development_dependency 'simplecov'
end
