module Utilities::CycleTimeObject
  def status_code=(new_code)
    if new_code.to_i >= Status.InProgress
      if in_progress_at == nil
        write_attribute(:in_progress_at,Time.now)
      end
    else
      write_attribute(:in_progress_at,nil)
    end
    if new_code.to_i >= Status.Done
      if done_at == nil
        write_attribute(:done_at,Time.now)
      end
    else
      write_attribute(:done_at,nil)
    end
    self.status = statuses.detect {|status| status.status_code.to_i == new_code.to_i}
    if !self.status
      @invalid_status = true
    end
  end
  
  def lead_time
    created_at == nil ? nil : time_since(created_at)
  end
  
  def cycle_time
    if in_progress_at == nil
      nil
    else
      time_since(in_progress_at)
    end
  end
  
protected

  # Return the time in days since orig time
  def time_since(orig)
    ((((done_at == nil ? Time.now : done_at) - orig).to_f / (60 * 60 * 24))*100).to_i / 100.to_f
  end
end