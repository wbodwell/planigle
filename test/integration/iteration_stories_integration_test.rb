require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../stories_test_helper"
require "#{File.dirname(__FILE__)}/resource_helper"

class IterationStoriesIntegrationTest < ActionDispatch::IntegrationTest
  include ResourceHelper
  include StoriesTestHelper

  fixtures :statuses
  fixtures :systems
  fixtures :individuals
  fixtures :releases
  fixtures :iterations
  fixtures :projects
  fixtures :individuals_projects
  fixtures :teams
  fixtures :stories
  
private

  # Return the url to get the resource (ex., resources)
  def resource_url
    '/planigle/api/iterations/1/stories'
  end

  # Answer a string representing the type of object. Ex., Story.
  def object_type
    'Stories'
  end

  # Return the parameters to use for a successful create.
  def create_success_parameters
    {:record => {:name => 'foo', :iteration_id => 1, :project_id => 1}}
  end

  # Return the parameters to use for a failed create.
  def create_failure_parameters
    {:record => {:name => '', :iteration_id => 1, :project_id => 1}}
  end
  
  # Answer the number of resources that exist.
  def resource_count
    iterations(:first).reload()
    iterations(:first).stories.length
  end

  # Verify that the object was created.
  def assert_create_succeeded
    iterations(:first).reload()
    assert iterations(:first).stories.find_by_name('foo')
  end
end