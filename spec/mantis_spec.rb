require_relative 'spec_helper'
      require 'base64'

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

