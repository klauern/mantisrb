gem 'minitest'
%w{ spec unit autorun pride }.each { |w|
  require "minitest/#{w}"
}
require 'mantisrb'

MANTISBT_URL = "http://www.mantisbt.org/demo"
MANTISBT = "mantisrb"
