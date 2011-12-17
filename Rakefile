# -*- encoding: utf-8 -*-
require 'bundler'
Bundler.setup
#Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

namespace :test do
  task :all => ['test']
end



require "rake"
require "rspec"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new("spec:unit") do |spec|
  spec.pattern = "spec/unit/**/*_spec.rb"
end

task :spec => [ "spec:unit" ]
task :default => :spec