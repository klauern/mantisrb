

require_relative 'spec_helper'

class ConfigTests < MiniTest::Unit::TestCase

  describe Mantis::Config do

    let :session do
      create_session
    end

    before do
      @configs = %w{ statuses priorities severities reproducibilities 
            projections etas resolutions access_levels
            project_statuses project_view_states view_states
            custom_field_types }
    end

    describe " config" do
      it "should retrieve statuses, priorities, severities, and more" do
        @configs.each { |w|
          session.config.send(w).size.must_be :>=, 1
        }
      end
      it "should return an array for all config types" do
        @configs.each { |c|
          assert_instance_of Array, session.config.send(c)
        }
      end
      it "should get the statuses of Mantis we're connecting to" do
        savon.stubs(:mc_enum_status).with(:status_request).returns(:statuses)
        #refute_nil session.config.statuses
        wont_be_nil_for(session.config.statuses, "acknowledged")
      end
      it "should get the priorities of Mantis we're connecting to" do
        wont_be_nil_for(session.config.priorities, "none")
      end
      it "should get the severities of Mantis we're connecting to" do
        wont_be_nil_for(session.config.severities, "feature")
      end
      it "should get the reproducibilities of Mantis we're connecting to" do
        wont_be_nil_for(session.config.reproducibilities, "always")
      end
      it "should get the version of Mantis we're connecting to" do
        session.config.version.wont_be_nil
      end
      it "should get the projections of Mantis we're connecting to" do
        wont_be_nil_for(session.config.projections, "none")
      end
      it "should get the ETA's of Mantis we're connecting to" do
        wont_be_nil_for(session.config.etas, "none")
      end
      it "should get the resolutions of Mantis we're connecting to" do
        wont_be_nil_for(session.config.resolutions, "open")
      end
      it "should get the access levels of Mantis we're connecting to" do
        wont_be_nil_for(session.config.access_levels, "viewer")
      end
      it "should get the project statuses of Mantis we're connecting to" do
        wont_be_nil_for(session.config.project_statuses, "development")
      end
      it "should get the project view states of Mantis we're connecting to" do
        wont_be_nil_for(session.config.project_view_states, "public")
      end
      it "should get the issue view states of Mantis we're connecting to" do
        wont_be_nil_for(session.config.view_states, "public")
      end
      it "should get the custom_field_types of Mantis we're connecting to" do
        wont_be_nil_for(session.config.custom_field_types, "Numeric")
      end
      it "project_status_for should convert :symbol to \"string\"" do
        session.config.object_ref_for_value(:project_status, :development).wont_be_empty
      end
      it "view_state_for should convert :symbol to \"string\"" do
        session.config.object_ref_for_value(:view_state, :public).wont_be_empty
      end
      it "access_min should convert :symbol to \"string\"" do
        session.config.object_ref_for_value(:access_min, :viewer).wont_be_empty
      end

      describe "statuses" do
        it "should map acknowledged status" do
          s = session.config.object_ref_for_value(:project_status, :release)
          assert s[:name] == "release"
        end

        describe "statuses" do
          it "should map acknowledged status" do
            s = session.config.object_ref_for_value(:project_status, :release)
            assert s[:name] == "release"
          end
        end # statuses

        describe "meta-method mapping" do
          meth_to_val = { status: :acknowledged,
                          priority: :none,
                          severity: :feature,
                          reproducibility: :always,
                          projection: :none,
                          eta: :none,
                          resolution: :open,
                          access_level: :viewer,
                          project_status: :development,
                          project_view_state: :public,
                          view_state: :public,
                          custom_field_type: :Numeric
          }
          meth_to_val.each { |k,v| 
            it "should find a list of ObjectRef Type for #{k}" do
              refute_nil session.config.object_ref_for_value(k,v)
            end
          }

        end # meta-method mapping
      end # config
    end # Mantis::Config
  end # ConfigTest
end # ConfigTests < MiniTest::Unit::TestCase
