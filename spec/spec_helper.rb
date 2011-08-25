gem 'minitest'
%w{ spec unit autorun pride }.each { |w|
  require "minitest/#{w}"
}
$:.unshift File.join(File.dirname(__FILE__), "../lib") # 'lib' directory
require 'mantisrb'

MANTIS_URL = "http://www.plangineering.com/nek/mantis"
MANTIS_USER = "admin"
MANTIS_PASS = "RFBDSlBxYURURXpCMXpoeA=="
