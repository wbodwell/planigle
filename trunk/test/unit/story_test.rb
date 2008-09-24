require File.dirname(__FILE__) + '/../test_helper'

class StoryTest < ActiveSupport::TestCase
  fixtures :teams
  fixtures :individuals
  fixtures :stories
  fixtures :projects
  fixtures :tasks
  fixtures :surveys
  fixtures :survey_mappings

  # Test that a story can be created.
  def test_create_story
    assert_difference 'Story.count' do
      story = create_story
      assert !story.new_record?, "#{story.errors.full_messages.to_sentence}"
    end
  end

  # Test the validation of name.
  def test_name
    validate_field(:name, false, nil, 250)
  end

  # Test the validation of description.
  def test_description
    validate_field(:description, true, nil, 4096)
  end

  # Test the validation of acceptance criteria.
  def test_acceptance_criteria
    validate_field(:acceptance_criteria, true, nil, 4096)
  end

  # Test the validation of priority.
  def test_priority
    assert_failure(:priority, 'a')
    assert_success(:priority, -1)
    assert_success(:priority, 0)
    assert_success(:priority, 1.345)
  end

  # Test the validation of effort.  Note: Effort should equal the sum of the tasks' efforts if nil.
  def test_effort
    assert_failure(:effort, 'a')
    assert_failure(:effort, -1)
    assert_failure(:effort, 0)
    
    story = stories(:first)
    assert_equal 1, story.effort
    story.effort=nil
    story.save(false)
    assert_nil story.effort
    assert_equal 5, story.calculated_effort
  end
  
  # Test calculating the effort from tasks.
  def test_calculated_effort
    assert_equal 5, stories(:first).calculated_effort
    assert_equal 5, stories(:first).calculated_effort_for(teams(:first), individuals(:aaron))
    assert_equal 0, stories(:first).calculated_effort_for(teams(:first), individuals(:quentin))
    assert_equal 1, stories(:second).calculated_effort_for(nil, nil)
    assert_equal 0, stories(:second).calculated_effort_for(teams(:first), nil)
  end

  # Test the validation of status.
  def test_status_code
    assert_success( :status_code, 0)
    assert_failure( :status_code, -1)
    assert_failure( :status_code, 3)    
  end

  # Test the validation of is_public.
  def test_is_public
    assert_success( :is_public, true)
    assert_success( :is_public, false)
  end

  # Test the accepted? method.
  def test_accepted
    assert !stories(:first).accepted?
    assert stories(:second).accepted?
  end
  
  # Test splitting a story.
  def test_split
    story = stories(:first).split
    assert_equal 'test Part Two', story.name
    assert_equal 1, story.project_id
    assert_equal 2, story.individual_id
    assert_equal 2, story.iteration_id
    assert_equal 'description', story.description
    assert_equal 'criteria', story.acceptance_criteria
    assert_equal 1, story.effort
    assert_equal 0, story.status_code
  end
  
  # Test splitting a story where the story ends up in the backlog.
  def test_split_last
    story = create_story(:iteration_id => 4, :release_id => 1 ).split
    assert_equal 'foo Part Two', story.name
    assert_equal 1, story.project_id
    assert_equal nil, story.individual_id
    assert_equal nil, story.iteration_id
    assert_equal 'bar', story.description
    assert_equal 'must', story.acceptance_criteria
    assert_equal 5, story.effort
    assert_equal 0, story.status_code
  end
  
  # Test splitting a story where the story starts in the backlog.
  def test_split_backlog
    story = create_story(:iteration_id => nil ).split
    assert_equal 'foo Part Two', story.name
    assert_equal 1, story.project_id
    assert_equal nil, story.individual_id
    assert_equal nil, story.iteration_id
    assert_equal 'bar', story.description
    assert_equal 'must', story.acceptance_criteria
    assert_equal 5, story.effort
    assert_equal 0, story.status_code
  end
  
  # Test splitting a story where the direct effort is null.
  def test_split_null_effort
    story = stories(:first)
    story.effort = nil
    story.save(false)
    assert_nil story.effort
    assert_equal 5, story.calculated_effort # Total of tasks
    story = story.split
    assert_nil story.calculated_effort
  end

  # Test that added stories are put at the end of the list.
  def test_priority_on_add
    assert_equal [3, 2, 1, 4] << create_story.id, Story.find(:all, :conditions => 'project_id = 1', :order=>'priority').collect {|story| story.id}    
  end
  
  # Test deleting an story (should delete tasks).
  def test_delete_story
    assert_equal tasks(:one).story, stories(:first)
    assert_equal survey_mappings(:first).story, stories(:first)
    stories(:first).destroy
    assert_nil Task.find_by_name('test')
    assert_nil SurveyMapping.find_by_id('1')
  end

  # Test that we can get a mapping of status to code.
  def test_status_code_mapping
    mapping = Story.status_code_mapping
    assert_equal ['Created',0], mapping[0]
  end

  # Test finding individuals for a specific user.
  def test_find
    assert_equal Story.count, Story.get_records(individuals(:quentin)).length
    assert_equal Story.find_all_by_project_id(1).length, Story.get_records(individuals(:aaron)).length
    assert_equal Story.find_all_by_project_id(1).length, Story.get_records(individuals(:user)).length
    assert_equal Story.find_all_by_project_id(1).length, Story.get_records(individuals(:readonly)).length
  end

private

  # Create a story with valid values.  Options will override default values (should be :attribute => value).
  def create_story(options = {})
    Story.create({ :name => 'foo', :description => 'bar', :effort => 5.0, :acceptance_criteria => 'must',
      :status_code => 0, :project_id => 1 }.merge(options))
  end
end