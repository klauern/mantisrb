require_relative 'spec_helper'

describe "Working With Projects" do

  before do
    @session = create_session
  end

  describe "getting info" do
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

  end # getting info

  describe "addition" do
    it "should create a new, basic project" do
      new_project = @session.projects.create params={
        :name => "Test_Project",
        :status => :development,
        :enabled => true,
        :view_state => :public,
        :inherit_global => true
      }
      new_project[:id].wont_be_nil
    end

    it "shouldn't accept incorrect status types" do
      skip
    end

    it "shouldn't accept incorrect view_states" do
      skip
    end

    it "shouldn't accept incorrect subprojects" do
      skip
    end
  end # addition

end # Working With Projects

