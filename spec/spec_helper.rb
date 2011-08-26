require 'base64'
gem 'minitest'
%w{ spec unit autorun pride }.each { |w|
  require "minitest/#{w}"
}
$:.unshift File.join(File.dirname(__FILE__), "../lib") # 'lib' directory
require 'mantisrb'

MANTIS_URL = "http://www.plangineering.com/nek/mantis"
MANTIS_USER = "admin"
MANTIS_PASS = "RFBDSlBxYURURXpCMXpoeA=="

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
