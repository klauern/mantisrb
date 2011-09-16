require_relative 'spec_helper'
require_relative 'savon_spec/macros'
Savon::Spec::Fixture.path = File.expand_path("../fixtures", __FILE__)
require 'mocha'
require 'mocha/integration/mini_test'

class TestStatus < MiniTest::Unit::TestCase
  include Savon::Spec::Macros

  def setup
    @session = create_session
  end

  def test_status_can_be_found
    savon.expects(:mc_enum_status).with(
      :username => "admin",
      :password => "DPCJPqaDTEzB1zhx").returns(:statuses)
    @session.config.statuses
  end
end
