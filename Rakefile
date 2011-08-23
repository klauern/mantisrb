require "bundler/gem_tasks"
require 'rake/testtask'
require 'rake/clean'

CLOBBER.include('pkg')

Rake::TestTask.new do |t|
  t.libs << "tests"
  t.pattern = "tests/*_spec.rb"
  #require 'minitest/autorun'
end

task :default => [:clobber, :test, :build]
