require_relative 'spec_helper'

describe Mantis::Issues do
  
  before do
    @projects = []
    @issues_list = []
    @session = create_session
    @project_id = @session.projects.create params={
      name: random_alphanumeric }
    @projects << @project_id
    @project = @session.projects.find_by_id(@project_id)
  end

  describe "creating issues" do
    it "should create a simple issue given a project" do
      id = @session.issues.add params={
        project: 45,
        summary: "Some Summary Description",
        description: "More Detailed Response will go here",
        category: "General" # Assuming it's part of all projects
      }
      wont_be_nil id
      @issues_list << id
    end
  end # creating issues

  describe "updating issues" do
    it "should update an issue if it exists" do
      skip
    end
  end # updating issues

  describe "deleting issues" do
    it "should delete an issue with an id" do
      id = @session.issues.add params={
        project: 45, # test has been defined by it for now, should refactor it out
        summary: random_alphanumeric,
        description: random_alphanumeric(256),
        category: "General"
      }
      @session.issues.delete?(id).must_equal true
    end
  end # deleting issues

  describe "listing issues" do
    it "should retrieve an issue by id" do
      @issue = @session.issues.by_id 1
      wont_be_nil @issue
    end

    it "should retrieve issue componetns by issue[:parameter] lookup" do
      @issue = @session.issues.by_id 1
      @issue[:id].to_i.must_be_same_as 1
    end

    it "should retrieve issue components by dot.method invocation" do
      @issue = @session.issues.by_id 1
      @issue.id.to_i.must_be_same_as 1
    end
  end # listing issues

  after do
    #clear_issues @project_id
    #clear_projects @session
    remove_given_projects(@session, @projects) if @projects # should be empty anyway
    remove_given_issues(@session, @issues_list) if @issues_list
  end
end # Mantis::Issues
