class System < ActiveRecord::Base
  # Summarize my recent data for reporting.  Add a day to the finish to make it end at the following day's midnight.
  def self.summarize
    Release.includes(:stories).where(['start < :now and finish + interval 14 day > :now', {now: Time.now}]).each { |release| release.summarize }
    Iteration.includes(:stories).where(['start < :now and finish + interval 14 day > :now', {now: Time.now}]).each { |iteration| iteration.summarize }
    Story.update_priorities
    Company.send_notifications
    Project.send_notifications
    create_demo
  end

  # Populate demo data.  You can modify / eliminate this in db/demo.sql.
  def self.create_demo
    sql = File.open("db/demo.sql").read
    sql.split(';').each do |sql_statement|
      if sql_statement.strip != ""
        ActiveRecord::Base.connection.execute(sql_statement)
      end
    end
  end

  # No one is authorized to create.  It is a singleton.
  def authorized_for_create?(current_user)
    false
  end

  # Everyone can read.
  def authorized_for_read?(current_user)
    true
  end

  # Only admins can write.
  def authorized_for_update?(current_user)    
    current_user.role == Individual::Admin
  end

  # No one is authorized to delete.  It is a singleton.
  def authorized_for_destroy?(current_user)
    false
  end
end