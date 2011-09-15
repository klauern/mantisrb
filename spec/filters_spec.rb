require_relative 'spec_helper'
class FiltersTest < MiniTest::Unit::TestCase
describe Mantis::Filters do

  let :session do
    create_session
  end

  describe "listing filters" do
    it "should list filters for a user" do
      skip
      prjs = session.projects.list
      filters = session.filters.list(prjs[0].id)
      assert_instance_of Array, filters.class
      if filters.size > 0
        assert_instance_of FilterData, filters[0]
      end
    end
  end # listing filters

  describe "issues in a filter" do
    it "should create an Array[] of IssueData for any filter" do
      skip
    end
    it "should return nil if no issues are found in a filter" do
      skip
    end
    it "should return a list of issue headers for a filter" do
      skip
    end
  end # issues in filter
end # Mantis::Filters
end # FiltersTest
