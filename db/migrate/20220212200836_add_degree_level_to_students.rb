class AddDegreeLevelToStudents < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :degree_level, :string
  end
end
