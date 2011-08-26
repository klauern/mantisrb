require_relative 'spec_helper'

describe "Working With Projects" do

  before do
    @session = create_session
  end

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

end

