require_relative 'spec_helper'
class ProjectsTests < MiniTest::Unit::TestCase
describe "Working With Projects" do

  let :session do
    create_session
  end

  before do
    @projects = []
  end

  describe "Getting Info" do
    it "should get a project list if there are projects" do
      proj_list = session.projects.list
      unless proj_list == nil
        assert_instance_of Array, session.projects.list
        #session.projects.project_list.class.must_be :==, Array
        %w{ id name status enabled view_state access_min 
              file_path description subprojects }.each { |w|
          wont_be_nil session.projects.list[0].send(w.to_sym)
        }
      end
    end 

    it "should return an array for any number of projects listed" do
      proj_list = session.projects.list
      assert_instance_of Array, proj_list
    end

    it "should generate a project if given an id" do
      skip
    end
  end # getting info

  describe "Issues" do

    it "should retrieve a list of Issues for a project name" do
      issues = session.projects.issues("test")
      assert_instance_of Array, issues
      assert_instance_of Mantis::XSD::IssueData, issues[0]
    end

  end # Issues

  describe "Categories" do
    #before do
      #@cat_prj_id = session.projects.create params={
        #name: random_alphanumeric
      #}
      #@cat_prj = session.projects.find_by_id @cat_prj_id
      #@category_hash = {} # Hash of project_id to array of categories to clean up afterwards
    #end

    it "should get the categories for a project" do
      skip
      #session.projects.categories(@cat_prj[:id]).wont_be_nil
    end

    it "should create a new category in a known project" do
      skip
      #@category_name = random_alphanumeric
      #num_of_categories = session.projects.categories @cat_prj[:id]
      #session.projects.add_category(@cat_prj[:id], @category_name).to_i.must_be :>, num_of_categories
    end

    it "should delete an existing category in a known project" do
      skip
    end

    it "should rename a category in a known project" do
      skip
    end

    after do
    end
  end # Projects :: Categories

  describe "Addition" do
    it "should create a new, basic project" do
      new_project_id = session.projects.create params={
        :name => random_alphanumeric,
        :project_status => "development",
        :enabled => true,
        :view_state => "public",
        :inherit_global => true
      }
      new_project_id.wont_be_nil
      @projects << new_project_id
    end
    it "should create a project with only a name" do
      new_project_id = session.projects.create params={
        name: random_alphanumeric 
      }
      new_project_id.wont_be_nil
      @projects << new_project_id
    end
    it "shouldn't accept incorrect project status types" do
      assert_raises RuntimeError do
        session.projects.create params={
          name: random_alphanumeric,
          status: "something that doesn't exist",
        }
      end
    end
    it "shouldn't accept incorrect view_states" do
      assert_raises RuntimeError do
        session.projects.create params={
          name: random_alphanumeric,
          view_state: "something non-existent"
        }
      end
    end
    it "shouldn't accept incorrect access minimum level" do
      assert_raises RuntimeError do
        session.projects.create params={
          name: random_alphanumeric,
          access_min: "I know this doesn't exist"
        }
      end
    end
    it "shouldn't accept incorrect subprojects" do
      assert_raises RuntimeError do
        session.projects.create params={
          subprojects: "blah blah blah bad"
        }
      end
    end

    describe "Of Subprojects" do
      it "can create projects as subprojects" do
        skip
      end
      it "can move subprojects from one to another" do
        skip
      end
      it "can have multiple nestings of subprojects" do
        skip
      end
    end # Subprojects
  end # Addition

  describe "Deletion" do
    before do
      @id = session.projects.create params={
        name: random_alphanumeric }
      @projects << @id
    end
    it "should delete a project with a valid project_id" do
      session.projects.delete?(@id).must_equal true
      @projects.delete @id
    end
    it "should delete a project with a string project_id" do
      session.projects.delete?(@id.to_s).must_equal true
      @projects.delete @id
    end
    it "should delete a project with an integer project_id" do
      session.projects.delete?(@id.to_i).must_equal true
      @projects.delete @id
    end
  end # deletion

  describe "listing" do
    before do
      @id = session.projects.create params={
        name: random_alphanumeric }
      @projects << @id
    end
    it "should return an array of hashes" do
      skip
    end
    it "should load a project if id is known" do
      proj = session.projects.find_by_id @id.to_i
      #binding.pry
      proj[:id].to_i.must_equal @id.to_i
    end
    it "should return nil if no project is found with a given id" do
      session.projects.find_by_id("million").must_be_nil
    end
  end # listing

  # Delete out all the projects that I was creating
  after do
    remove_given_projects(session, @projects)
  end

end # Working With Projects

end # ProjectsTests
