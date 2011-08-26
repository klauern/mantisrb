require_relative 'spec_helper'

describe Mantis::Session do

  before do
    @session = create_session
  end

  describe "Mantis" do
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
    end # config

    describe " projects" do
      
      it "should get a project list if there are projects" do
        proj_list = @session.projects.project_list
        unless proj_list == nil
          @session.projects.project_list.class.must_be :==, Hash
          %w{ id name status enabled view_state access_min 
              file_path description subprojects }.each { |w|
            @session.projects.project_list.must_include w.to_sym
          }
        end
      end

    end # projects
  end # Mantis
end # Mantis::Session

