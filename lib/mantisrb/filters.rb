module Mantis

  # Filters are Mantis' way of saving a search query for re-use.  You can't
  # create a filter through the MantisConnect API, so currently, this is only
  # for retrieving issues by a filter, or getting a list of filters from
  # a project.
  class Filters

    # Create a Filters instance for searching
    # @param [Mantis::Session] session
    def initialize session
      @session = session
    end

    # Get a list of {Mantis::XSD::FilterData} by project id.
    # @param [Integer] project_id
    # @return [Array<Mantis::XSD::FilterData>] List of filters
    def by_project(project_id)
      filters = [] << @session.response_trimmed(:mc_filter_get, {
        project_id: project_id
      })
      filters.map { |f| Mantis::XSD::FilterData.new f }
    end

    # @see {#by_project}
    alias :list :by_project

    # Get the raw issue data returned from MantisConnect's SOAP interface by applying 
    # a filter on a list of issues in a project
    # @param [Integer] project_id
    # @param [Integer] filter_id
    # @param [Integer] page_num Which Page number of results to retrieve (0 by
    # default)
    # @param [Integer] per_page How many issues to return per page (50 by
    # default)
    # @return [Hash] Raw XML return of Issues
    def raw_issues_for(project_id, filter_id, page_num=0, per_page=50)
      @session.response_trimmed :mc_filter_get_issues, {
        project_id: project_id,
        filter_id: filter_id,
        page_number: page_num,
        per_page: per_page
      }
    end

    # Get a list of {Mantis::XSD::IssueData} issues by applying a filter on
    # a list of issues in a project.  Parameters are the same as
    # {#raw_issues_for}, but this wraps the results into manageable
    # {Mantis::XSD::IssueData} objects.
    # @param [Integer] project_id
    # @param [Integer] filter_id
    # @param [Integer] page_num which page number of results to return (first
    # page by default)
    # @param [Integer] per_page How many results to retrieve per page (50 by
    # default)
    # @return [Array<Mantis::XSD::IssueData>] array of issues that you can work
    # with.
    def issues_for(project_id, filter_id, page_num=0, per_page=50)
      raw = raw_issues_for(project_id, filter_id, page_num, per_page)
      issues = raw.map { |issue| Mantis::XSD::IssueData.new issue }
    end
  end # Filters
end # Mantis
