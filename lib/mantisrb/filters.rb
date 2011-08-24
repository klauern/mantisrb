module Mantis

  class Filters

    def initialize session
      @session = session
    end

    def by_project_id(id)
      @session.response :mc_filter_get, { :project_id => id }
    end
  end
end
