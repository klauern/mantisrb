
require 'rr'

extend RR::Adapters::RRMethods

def expect_project_list
  mock(Mantis::Projects).list { [] }
end

def expect_single_issue_array
end

def expect_multiple_issue_array
end


