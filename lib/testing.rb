# This is a testing file for use within an IRB session.
# I have this simply to save myself the time of composing a session.
#
# Run it by typing `irb -rtesting` within the 'lib/' folder

$:.unshift(File.expand_path(File.dirname(__FILE__)))
require 'mantisrb'
require 'base64'

PASS = Base64.decode64(ENV['MANTIS_PASS'])
URL = ENV['MANTIS_URL']
USER = ENV['MANTIS_USER']
SESSION = Mantis::Session.new URL, USER, PASS
