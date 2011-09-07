require_relative 'spec_helper'

describe Mantis::Filters do

  before do
    @session = create_session
  end

  describe "listing filters" do
    it "should list filters for a user" do
      skip
      prjs = @session.projects.list
      filters = @session.filters.list(prjs[0].id)
      if filters.size > 0
        must_be_same Array, filters.class, "Filters must create an Array[]"
      end
    end
  end # listing filters

  describe "issues in a filter" do
    it "should return an Array[] of IssueData for a filter" do
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
