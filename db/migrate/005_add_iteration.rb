class AddIteration < ActiveRecord::Migration[4.2]
  def self.up
    add_column :stories, :iteration_id, :integer
  end

  def self.down
    remove_column :stories, :iteration_id
  end
end
