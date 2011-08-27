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
    it "should get the version of Mantis we're connecting to" do
      @session.config.version.must_match "1.2"
    end

    it "project_status_for should convert :symbol to \"string\"" do
      @session.config.project_status_for(:development).wont_be_empty
    end
    it "view_state_for should convert :symbol to \"string\"" do
      @session.config.view_state_for(:public).wont_be_empty
    end
    it "access_min should convert :symbol to \"string\"" do
      @session.config.access_min(:public).wont_be_empty
    end
  end # config
end
