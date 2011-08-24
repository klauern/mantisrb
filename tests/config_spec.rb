require_relative 'test_helper'


describe Mantis::Session do
  
  before do
    @session = Mantis::Session.new MANTISBT_URL, MANTISBT, MANTISBT
  end

  it "should strip all :\"@xsi:type\" elements" do
    @session.config.statuses.each { |t| t.keys.wont_include :"@xsi:type" }
  end
end
