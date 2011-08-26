module Mantis

  class Project
    attr_accessor :name, :status, :enabled, :view_state, :inherit_global
    attr_accessor :access_min, :file_path, :description, :subprojects
    attr_reader :id
  end
end

