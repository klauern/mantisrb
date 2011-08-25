require_relative 'spec_helper'


describe Mantis::Session do

  before do
    if ENV['MANTIS_USER'] && ENV['MANTIS_PASS'] && ENV['MANTIS_URL']
      @session = Mantis::Session.new ENV['MANTIS_URL'], ENV['MANTIS_USER'],
        Base64.decode64(ENV['MANTIS_PASS'])
    else
      @session = Mantis::Session.new MANTIS_URL, MANTIS_USER, 
        Base64.decode64(MANTIS_PASS)
    end
  end

  it "should strip all :\"@xsi:type\" elements" do
    @session.config.statuses.each { |t| t.keys.wont_include :"@xsi:type" }
  end
end
