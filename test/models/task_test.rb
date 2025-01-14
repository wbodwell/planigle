require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < ActiveSupport::TestCase
  fixtures :statuses
  fixtures :individuals
  fixtures :stories
  fixtures :tasks

  # Test that a task can be created.
  def test_create_task
    assert_difference 'Task.count' do
      task = create_task
      assert !task.new_record?, "#{task.errors.full_messages.to_sentence}"
    end
  end

  # Test that you can't create a task without a story.
  def test_create_task_without_story
    assert_no_difference 'Task.count' do
      task = Task.create({:name => 'foo', :description => 'bar', :effort => 5.0, :status_code => 0})
    end
  end
  
  # Test the validation of name.
  def test_name
    validate_field(:name, false, nil, 250)
  end

  # Test the validation of description.
  def test_description
    validate_field(:description, true, nil, 20480)
  end

  # Test the validation of reason blocked.
  def test_reason_blocked
    validate_field(:reason_blocked, true, nil, 4096)
  end

  # Test the validation of priority.
  def test_priority
    assert_failure(:priority, 'a')
    assert_success(:priority, -1)
    assert_success(:priority, 0)
    assert_success(:priority, 1.345)
  end

  # Test the validation of effort.
  def test_effort
    assert_failure(:effort, 'a')
    assert_failure(:effort, -1)
    assert_success(:effort, 0)
  end

  # Test the validation of estimate.
  def test_estimate
    assert_failure(:estimate, 'a')
    assert_failure(:estimate, -1)
    assert_success(:estimate, 0)
  end

  # Test the validation of actual.
  def test_actual
    assert_failure(:actual, 'a')
    assert_failure(:actual, -1)
    assert_success(:actual, 0)
  end

  # Test the validation of status code.
  def test_status_code
    assert_success( :status_code, 0)
    assert_failure( :status_code, -1 )
    assert_success( :status_code, 3 )
    assert_failure( :status_code, 4 )
  end

  # Test the validation of status.
  def test_status
    assert_equal "In Progress", tasks(:one).status.name
    assert_equal "Done", tasks(:two).status.name
    assert_equal "Blocked", tasks(:three).status.name
  end

  # Test the is_done method.
  def test_is_done
    assert !tasks(:one).is_done
    assert tasks(:two).is_done
  end
  
  # Validate is_blocked.
  def test_is_blocked
    assert !tasks(:one).is_blocked
    assert tasks(:three).is_blocked
    assert tasks(:three).blocked_message
  end
  
  # Validate matching
  def test_matches
    assert tasks(:one).matches(:individual_id => 2, :status_code => 1)
    assert tasks(:one).matches(:individual_id => 2, :status_code => 'NotDone')
    assert !tasks(:one).matches(:individual_id => 3, :status_code => 'NotDone')
    assert !tasks(:one).matches(:individual_id => nil, :status_code => 'NotDone')
    assert tasks(:three).matches(:individual_id => nil, :status_code => 'NotDone')
  end

  def test_in_progress_at
    task = tasks(:one)
    task.status_code = Status.Created
    assert_nil task.in_progress_at
    task.status_code = Status.InProgress
    assert task.in_progress_at != nil
    task.status_code = Status.Blocked
    assert task.in_progress_at != nil
    task.status_code = Status.Done
    assert task.in_progress_at != nil
  end
  
  def test_done_at
    task = tasks(:one)
    task.status_code = Status.Created
    assert_nil task.done_at
    task.status_code = Status.InProgress
    assert_nil task.done_at
    task.status_code = Status.Blocked
    assert_nil task.done_at
    task.status_code = Status.Done
    assert task.done_at != nil
  end

  def test_lead_time
    task = tasks(:one)
    task.created_at = Time.utc(2010,1,1,12,0,0)
    task.done_at = Time.utc(2010,1,5,18,0,0)
    assert_equal 4.25, task.lead_time

    task = stories(:first)
    task.created_at = Time.now - 24*60*60
    task.done_at = nil
    assert_equal 1, task.lead_time.to_i
  end
  
  def test_cycle_time
    task = tasks(:one)
    task.in_progress_at = Time.utc(2010,1,1,12,0,0)
    task.done_at = Time.utc(2010,1,5,18,0,0)
    assert_equal 4.25, task.cycle_time

    task.in_progress_at = Time.now - 24*60*60
    task.done_at = nil
    assert_equal 1, task.cycle_time.to_i

    task.in_progress_at = nil
    task.done_at = nil
    assert_nil task.cycle_time
  end

private

  # Create a task with valid values.  Options will override default values (should be :attribute => value).
  def create_task(options = {})
    Task.create({ :story_id => 1, :name => 'foo', :description => 'bar', :effort => 5.0,
      :status_code => 0 }.merge(options))
  end
end
