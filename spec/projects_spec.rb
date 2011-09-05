require_relative 'spec_helper'

describe "Working With Projects" do

  before do
    @session = create_session
    @projects = []
    @category_hash = {} # Hash of project_id to array of categories to clean up afterwards
  end

  describe "Getting Info" do
    it "should get a project list if there are projects" do
      proj_list = @session.projects.list
      unless proj_list == nil
        @session.projects.project_list.class.must_be :==, Array
        %w{ id name status enabled view_state access_min 
              file_path description subprojects }.each { |w|
          @session.projects.project_list[0].must_include w.to_sym
        }
      end
    end 
  end # getting info

  describe "Categories" do
    it "should get the categories for a project" do
      proj = @session.projects.list[0]
      @session.projects.categories(proj[:id]).wont_be_nil
    end

    it "should create a new category in a known project" do
      skip
    end

    it "should delete an existing category in a known project" do
      skip
    end

    it "should rename a category in a known project" do
      skip
    end
  end # Projects :: Categories

  describe "Addition" do
    it "should create a new, basic project" do
      new_project_id = @session.projects.create params={
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
      new_project_id = @session.projects.create params={
        name: random_alphanumeric 
      }
      new_project_id.wont_be_nil
      @projects << new_project_id
    end

    it "shouldn't accept incorrect project status types" do
      assert_raises RuntimeError do
        @session.projects.create params={
          name: random_alphanumeric,
          status: "something that doesn't exist",
        }
      end
    end

    it "shouldn't accept incorrect view_states" do
      assert_raises RuntimeError do
        @session.projects.create params={
          name: random_alphanumeric,
          view_state: "something non-existent"
        }
      end
    end

    it "shouldn't accept incorrect access minimum level" do
      assert_raises RuntimeError do
        @session.projects.create params={
          name: random_alphanumeric,
          access_min: "I know this doesn't exist"
        }
      end
    end

    it "shouldn't accept incorrect subprojects" do
      assert_raises RuntimeError do
        @session.projects.create params={
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
    end

  end # addition

  describe "Deletion" do

    before do
      @id = @session.projects.create params={
        name: random_alphanumeric }
      @projects << @id
    end

    it "should delete a project with a valid project_id" do
      @session.projects.delete?(@id).must_equal true
      @projects.delete @id
    end

    it "should delete a project with a string project_id" do
      @session.projects.delete?(@id.to_s).must_equal true
      @projects.delete @id
    end

    it "should delete a project with an integer project_id" do
      @session.projects.delete?(@id.to_i).must_equal true
      @projects.delete @id
    end
  end # deletion

  describe "listing" do
    before do
      @id = @session.projects.create params={
        name: random_alphanumeric }
      @projects << @id
    end

    it "should return an array of hashes" do
      skip
    end

    it "should load a project if id is known" do
      proj = @session.projects.find_by_id @id.to_i
      proj[:id].to_i.must_be_same_as @id.to_i
    end

    it "should return nil if no project is found with a given id" do
      @session.projects.find_by_id("million").must_be_nil
    end
  end # listing

  # Delete out all the projects that I was creating
  after do
    remove_given_projects(@session, @projects)
  end

end # Working With Projects

