class AddIterationNotable < ActiveRecord::Migration[4.2]
  def self.up
    add_column :iterations, :notable, :string, :limit => 40, :default => ""
  end

  def self.down
    remove_column :iterations, :notable
  end
end