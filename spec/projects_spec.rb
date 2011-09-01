require_relative 'spec_helper'

describe "Working With Projects" do

  before do
    @session = create_session
  end

  describe "getting info" do
    it "should get a project list if there are projects" do
      proj_list = @session.projects.project_list
      unless proj_list == nil
        @session.projects.project_list.class.must_be :==, Array
        %w{ id name status enabled view_state access_min 
              file_path description subprojects }.each { |w|
          @session.projects.project_list[0].must_include w.to_sym
        }
      end
    end 

  end # getting info

  describe "addition" do
    it "should create a new, basic project" do
      new_project_id = @session.projects.create params={
        :name => random_alphanumeric,
        :status => "development",
        :enabled => true,
        :view_state => "public",
        :inherit_global => true
      }
      new_project_id.wont_be_nil
    end

    it "should create a project with only a name" do
      new_project_id = @session.projects.create params={
        name: random_alphanumeric }
        new_project_id.wont_be_nil
    end

    it "shouldn't accept incorrect status types" do
      @session.projects.create params={
        name: random_alphanumeric,
        status: "somethign that doesn't exist",
      }.must_throw
      #skip
    end

    it "shouldn't accept incorrect view_states" do
      @session.projects.create params={
        name: random_alphanumeric,
        view_state: "something non-existent"
      }.must_throw
    end

    it "shouldn't accept incorrect subprojects" do
      @session.projects.create params={
        subprojects: "blah blah blah bad"
      }.must_throw
    end

    describe "of subprojects" do
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

  describe "deletion" do

    before do
      @id = @session.projects.create params={
        name: random_alphanumeric }
    end

    it "should delete a project with a valid project_id" do
      @session.projects.delete?(@id).must_equal true
    end
  end # deletion

  describe "listing" do

    it "should return an array of hashes" do
      skip
    end

  end # listing

  # Delete out all the projects that I was creating
  after do
    clear_projects @session
  end

end # Working With Projects

