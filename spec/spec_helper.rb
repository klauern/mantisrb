require 'simplecov'  
SimpleCov.start do  
  add_filter 'spec/'
end

require 'base64'
require 'bundler/setup'
require 'pry'

gem 'minitest'
%w{ spec unit mock autorun pride }.each { |w|
  require "minitest/#{w}"
}
$:.unshift File.join(File.dirname(__FILE__), "../lib") # 'lib' directory
require 'mantisrb'

#require 'mocha/integration/mini_test'
require 'mocha'
require_relative 'savon_spec/macros'
Savon::Spec::Fixture.path = File.expand_path("../fixtures", __FILE__)
include Savon::Spec::Macros

MANTIS_URL = "http://www.plangineering.com/nek/mantis"
MANTIS_USER = "admin"
MANTIS_PASS = "RFBDSlBxYURURXpCMXpoeA=="

Savon.configure do |config|
  config.log = false
  config.log_level = :info
end
HTTPI.log = false

def create_session
  if ENV['MANTIS_USER'] && ENV['MANTIS_PASS'] && ENV['MANTIS_URL']
    session = Mantis::Session.new ENV['MANTIS_URL'], ENV['MANTIS_USER'],
      Base64.decode64(ENV['MANTIS_PASS'])
  else
    session = Mantis::Session.new MANTIS_URL, MANTIS_USER, 
      Base64.decode64(MANTIS_PASS)
  end
  session
end

def wont_be_nil_for(response, expectation)
  response.select { |x| x.value? expectation }.wont_be_nil
end

# Gleaned from DZone: http://snippets.dzone.com/posts/show/2111
def random_alphanumeric(size=16)
  s = ""
  size.times { s << (i = Kernel.rand(62); i += ((i<10) ? 48 : ((i< 36) ? 55 : 61))).chr }
  s
end

# remove all projects from remote server except ones matching these names
def clear_projects(session, except_these=["test"])
  list = session.projects.list
  list.each { |l|
    if list[0].class == Hash and not except_these.member? l[:name]
      session.projects.delete? l[:id].to_i
    end
  }
end

# Useful for clearing out a list of projects by id name
def remove_given_projects(session, list)
  list.each { |l|
    session.projects.delete? l.to_i
  }
end

# Useful for clearing out a list of issues by id name
def remove_given_issues(session, list)
  list.each { |l|
    session.issues.delete? l.to_i
  }
end

def remove_categories_from_project(project_id, categories)
  categories.each { |cat|
    session.projects.remove_category(project_id, cat)
  }
end
