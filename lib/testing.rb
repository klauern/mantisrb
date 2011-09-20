# This is a testing file for use within an IRB session.
# I have this simply to save myself the time of composing a session.
#
# Run it by typing `irb -rtesting` within the 'lib/' folder
#
# Also, you may notice the ENV['MANTIS_*'] pieces.  For the variables, 
# see the following:
#
# ENV['MANTIS_URL'] = http://www.server.com/mantis
# ENV['MANTIS_USER'] = whatever user
# ENV['MANTIS_PASS'] = Base64.encode64("password") # security through
# obscurity, I know, but I wanted it not to be plaintext-visible

$:.unshift(File.expand_path(File.dirname(__FILE__)))
require 'mantisrb'
require 'base64'

# Retrieve a Password from the environment that is Base64 encoded (just for
# obfuscation) (MANTIS_PASS)
PASS = Base64.decode64(ENV['MANTIS_PASS'])
# Retrieve a URL to Mantis from your environment (MANTIS_URL)
URL = ENV['MANTIS_URL']
# Retrieve the user name to log in as (MANTIS_USER) from your environment
USER = ENV['MANTIS_USER']
# Create a Session with your environment settings (MANTIS_URL, MANTIS_USER,
# MANTIS_PASS)
SESSION = Mantis::Session.new URL, USER, PASS

binding.pry
