require_relative 'spec_helper'

describe Mantis::Issues do
  
  before do
    @session = create_session
    @project_id = @session.projects.create params={
      name: random_alphanumeric }
    @project = @session.projects.find_by_id(@project_id)
  end

  describe "creating issues" do
    it "should create a simple issue given a project" do
      skip
    end
  end # creating issues

  describe "deleting issues" do
    it "should delete an issue with an id" do
      skip
    end
  end # deleting issues

  describe "listing issues" do

    it "should retrive an issue by id" do
      #@issue = @session.issues.find_by_id
      skip
    end
  end

  after do
    #clear_issues @project_id
    clear_projects @session
  end
end # Mantis::Issues
