module StoryAttributesTestHelper
  # Return the parameters to use for a successful create.
  def create_success_parameters
    {:record => {:name => 'foo', :value_type => 0, :project_id => 1}}
  end

  # Return the parameters to use for a failed create.
  def create_failure_parameters
    {:record => {:name => '', :value_type => 0, :project_id => 1}}
  end

  # Return the parameters to use for a successful update.
  def update_success_parameters
    {:record => {:name => 'foo'}, :project_id => 1}
  end

  # Return the parameters to use for a failed update.
  def update_failure_parameters
    {:record => {:name => ''}, :project_id => 1}
  end
  
  # Answer the context for this resource (if contained within scope of others).
  def context
    {}
  end
  
  # Answer the number of resources that exist.
  def resource_count
    StoryAttribute.count
  end

  # Verify that the object was created.
  def assert_create_succeeded
    assert StoryAttribute.where(name: 'foo').first
  end

  # Verify that the object was updated.
  def assert_update_succeeded
    assert StoryAttribute.where(name: 'foo').first
  end

  # Verify that the object was not created / updated.
  def assert_change_failed
    assert_nil StoryAttribute.where(name: '').first
  end

  # Verify that the object was not created / updated with valid changes.
  def assert_valid_change_failed
    assert_nil StoryAttribute.where(name: 'foo').first
  end

  # Verify that the object was deleted.
  def assert_delete_succeeded
    assert_nil StoryAttribute.where(name: 'Test_Text', project_id: 1).first
  end

  # Verify that the object was not deleted.
  def assert_delete_failed
    assert StoryAttribute.where(name: 'Test_Text').first
  end
  
  def base_URL
    '/planigle/api/story_attributes'
  end
end