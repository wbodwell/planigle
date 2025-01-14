class AddSurveyDetails < ActiveRecord::Migration[4.2]
  def self.up
    add_column :surveys, :name, :string, :limit => 80, :null => false
    add_column :surveys, :company, :string, :limit => 80
    Survey.find_each {|survey| survey.name = survey.email.slice(0,80); survey.save( :validate=> false )}
  end

  def self.down
    remove_column :surveys, :company
    remove_column :surveys, :name
  end
end
