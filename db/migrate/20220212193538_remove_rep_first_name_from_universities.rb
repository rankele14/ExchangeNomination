class RemoveRepFirstNameFromUniversities < ActiveRecord::Migration[6.1]
  def change
    remove_column :universities, :rep_first_name, :string
    remove_column :universities, :rep_last_name, :string
    remove_column :universities, :rep_title, :string
    remove_column :universities, :rep_email, :string
    remove_column :universities, :num_students, :integer
  end
end
