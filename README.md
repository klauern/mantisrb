mantisrb [![Build Status](http://travis-ci.org/klauern/mantisrb.png)](http://travis-ci.org/klauern/mantisrb)
========

`mantisrb` is an API that works with the [Savon][1] gem to talk to a [Mantis][2]
bug tracker through SOAP calls.  Mantis' SOAP interface is called [MantisConnect][3]
(see [example][4] for an API view).

Usage
-----
Install:

``` ruby
gem install mantisrb
```

Create a session to the Mantis server:

```ruby
session = Mantis:Session.new "http://mantisurl.com/mantis", "YourUsername", "YourPassword"
```

Various components are described below:

Config
------
Configuration details about the Mantis installation can be retrieved, such
as finding out the status types, access levels, and view states:

```ruby
session.config.priorities # get priorities
session.config.statuses # possible issue statuses
session.config.version # Mantis version
session.config.access_levels
```

More information on this can be found in {Mantis::Config}.

Projects
--------
Get a list of projects that your user can access:

```ruby
    session.projects.list
```

Create a project:

```ruby
    project_id = session.projects.create params={
      name: "project name"  # Minimally, this is all you need
    }
```

Or provide more details (some shown below):

```ruby
    project = session.projects.create {
      name: "project thing",
      status: "development"
      enabled: true,
      view_state: :public # or 'public', or session.projects.status.public,
      inherit_from_global: true
    }

    project.name  # "project thing"
    project.id    # 10 or whatever for referencing
    project......
```

More details on what is in a project can be found in {Mantis::XSD::ProjectData}.

Issues
------
Getting issues is easy, too:

by id:

```ruby
    session.issues.by_id 110 # if you know the id
    session.issues.exists? 110 # if you don't know if it's there
    session.issues.by_name "problem name I solved" # name of Mantis issue that
    you want to search explicitly by (no wildcards or regex'ing, sorry)

    session.projects.issues "project name" # get first 100 issues by Project Name
```

by ugly Mantis summary searching:

```ruby
    session.issues.summary_matches "some regex"  # Do some ssearching (mind, it
    is going to be pretty slow)
```

by project id:

```ruby
    session.issues.by_project_id project_id, page_#, issues_per_page # The
    fully flexible way of getting a list of issues
    session.issues.by_project_id project_id # gets you an Enumerable to go
    through things
    session.issues.by_project_id project_id, limit # number of issues to get at
    once
```

Creating them isn't too bad (know your options):

```ruby
    issue = session.issues.create {
      summary: "issue description somewhere here",
      priority: :high,
      due_date: "10/13/2011 08:45 AM" # or other formats as DateTime will
      accept
    }
```

Required fields for an issue:
  - project (`id` or `name` of project will work)
  - summary
  - description
  - category name (you can get this from the project)
    

Information on what is in an Issue can be found in the {Mantis::XSD::IssueData}
class.

### Issue Check-in

Issues can be updated with comments or completion with this quick call to an
issue:

```ruby
    session.issues.checkin(issue_id, comment, completed?) # defaults to false
```

Filters
-------
Filters are Mantis' way of saving a configured search.  You likely know what
they are if you have used Mantis, so if not, please take a brief look at [this
blogpost][6] to see what you can use filters for.


Get a filter by `id`:

```ruby
    session.filters.by_project_id 110 # get all filters you can search by for the project_id
```

Get issues for a particular filter:

```ruby
    session.filters.get_issues project_id # get first 100 issues for a given
    filter
    session.filters.get_issues project_id, page_num, issues_per_page
    # fully-formatted search
```

Creation/Deletion/Etc., actions on Filters are unsupported as Mantis' SOAP API
does not support it.

Categories in Projects
----------------------
When creating issues, you will need to know what category the issue belongs to, so this should be
helpful.

Get all categories for a project:

```ruby
    session.projects.categories(project_id)
```

Add a category

```ruby
    session.projects.add_category(45, "Triage")
    session.projects.add_category(<project_id>, <category_name>)
```

Delete a category


```ruby
    session.projects.delete_category(<project_id>, <category_name>)
```

Rename a category


```ruby
    session.projects.rename_category params={
      project_id: <id>,
      old_category: <category_name>,
      new_category: <new_category_name>,
      project_assigned_to: <id> # leaving this out will keep it in the same
      project
    }
```



Compatibility
-------------
You can see which environments have been tested on [Travis CI][travis].  JRuby support 
is lacking, as it appears there might be an issue with [Nokogiri][nok] and 
[Savon][sav] gems (to be determined).  Any help in getting JRuby to work (w/
JRUBY_OPTS=--1.9) would be greatly appreciated.


License, Open-Source-ness, and other Miscellany
===============================================
I've licensed `mantisrb` with the [MIT License][5], which should be permissive
enough for you to muck around and fiddle with.  It's open-source, so
contributions are welcomed and encouraged.

For any questions / suggestions / contributions, contact me at:

Email: klauer - at - gmail - dot - com for more information or send me a pull-request.


 [1]: http://www.savonrb.com
 [2]: http://www.mantisbt.org
 [3]: http://www.futureware.biz/mantisconnect/concept.php
 [4]: http://www.mantisbt.org/demo/api/soap/mantisconnect.php
 [5]: http://www.opensource.org/licenses/mit-license.php
 [6]: http://www.mantisbt.org/blog/?p=6
 [nok]: http://nokogiri.org/Nokogiri/XML/Builder.html
 [sav]: http://www.savonrb.com/
 [travis]: http://travis-ci.org/#!/klauern/mantisrb
