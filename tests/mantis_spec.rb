require_relative 'test_helper'


describe Mantis::Session do

  before do
    if ENV['MANTIS_USER'] && ENV['MANTIS_PASS'] && ENV['MANTIS_URL']
      require 'base64'
      @session = Mantis::Session.new ENV['MANTIS_URL'], ENV['MANTIS_USER'],
        Base64.decode64(ENV['MANTIS_PASS'])
    else
      @session = Mantis::Session.new MANTISBT_URL, MANTISBT, MANTISBT
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
      it "should get a list of statuses" do
        @session.config.statuses.size.must_be :>=, 1
      end
      it "should get a list of priorities" do
        @session.config.priorities.size.must_be :>=, 1
      end
      it "should get a list of severities" do
        @session.config.severities.size.must_be :>=, 1
      end
      it "should get a list of reproducibilities" do
        r = @session.config.reproducibilities
        r.size.must_be :>=, 1
      end
      it "should get the version of Mantis we're connecting to" do
        assert_equal "1.2.5", @session.config.version
      end
      it "should get projections" do
        @session.config.projections.size.must_be :>=, 1
      end
    end # config

    describe " projects" do
      
      it "should get a project list" do
        @session.projects.project_list.class.must_be :==, Hash
        %w{ id name status enabled view_state access_min 
            file_path description subprojects }.each { |w|
          @session.projects.project_list.must_include w.to_sym
        }
      end

    end # projects
  end # Mantis
end # Mantis::Session

