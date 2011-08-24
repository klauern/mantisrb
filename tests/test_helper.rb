gem 'minitest'
%w{ spec unit autorun pride }.each { |w|
  require "minitest/#{w}"
}
$:.unshift File.join(File.dirname(__FILE__), "../lib") # 'lib' directory
require 'mantisrb'

MANTISBT_URL = "http://www.mantisbt.org/demo"
MANTISBT = "mantisrb"
