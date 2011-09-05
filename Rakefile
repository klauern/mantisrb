require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/clean'
require 'rake'
require 'yard'

CLOBBER.include('pkg')
CLOBBER.include('doc')

Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
end

desc "Run all BDD Specs with MiniTest::Spec"
task :spec do
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/spec'))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

  gem 'minitest'  # use the gem, it's got more in it than the 1.9 minitest
  require 'minitest/autorun'

  spec_files = Dir['spec/**/*_spec.rb']
  spec_files.each { |f| require f }
end

task :default => [:clobber, :spec, :build]

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'spec/**/*.rb', ] # optional
  t.options= [ '--files', 'LICENSE' ]
  #t.options = ['--any', '--extra', '--opts'] # optional
end
