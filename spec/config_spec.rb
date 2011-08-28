require_relative 'spec_helper'


describe Mantis::Session do


  before do
    @session = create_session
  end


  describe " config" do

    it "should retrieve statuses, priorities, severities, and more" do
      %w{ statuses priorities severities reproducibilities 
            version projections etas resolutions access_levels
            project_status project_view_states view_states
            custom_field_types }.each { |w|

        @session.config.send(w).size.must_be :>=, 1
      }
    end

    it "should get the statuses of Mantis we're connecting to" do
      wont_be_nil_for(@session.config.statuses, "acknowledged")
    end
    it "should get the priorities of Mantis we're connecting to" do
      wont_be_nil_for(@session.config.priorities, "none")
    end
    it "should get the severities of Mantis we're connecting to" do
      wont_be_nil_for(@session.config.severities, "feature")
    end
    it "should get the reproducibilities of Mantis we're connecting to" do
      wont_be_nil_for(@session.config.reproducibilities, "always")
    end
    it "should get the version of Mantis we're connecting to" do
      @session.config.version.must_match "1.2"
    end
    it "should get the projections of Mantis we're connecting to" do
      wont_be_nil_for(@session.config.projections, "none")
    end
    it "should get the ETA's of Mantis we're connecting to" do
      wont_be_nil_for(@session.config.etas, "none")
    end
    it "should get the resolutions of Mantis we're connecting to" do
      @session.config.resolutions.must_match "1.2"
    end
    it "should get the access levels of Mantis we're connecting to" do
      @session.config.access_levels.must_match "1.2"
    end
    it "should get the project statuses of Mantis we're connecting to" do
      @session.config.project_status.must_match "1.2"
    end
    it "should get the project view states of Mantis we're connecting to" do
      @session.config.project_view_states.must_match "1.2"
    end
    it "should get the issue view states of Mantis we're connecting to" do
      @session.config.view_states.must_match "1.2"
    end
    it "should get the custom_field_types of Mantis we're connecting to" do
      @session.config.custom_field_types.must_match "1.2"
    end

    it "project_status_for should convert :symbol to \"string\"" do
      @session.config.project_status_for(:development).wont_be_empty
    end
    it "view_state_for should convert :symbol to \"string\"" do
      @session.config.view_state_for(:public).wont_be_empty
    end
    it "access_min should convert :symbol to \"string\"" do
      @session.config.access_min(:viewer).wont_be_empty
    end
  end # config
end
