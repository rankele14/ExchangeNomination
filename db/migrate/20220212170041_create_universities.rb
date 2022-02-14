class CreateUniversities < ActiveRecord::Migration[6.1]
  def change
    create_table :universities do |t|
      t.string :university_name
      t.string :rep_first_name
      t.string :rep_last_name
      t.string :rep_title
      t.string :rep_email
      t.integer :num_students

      t.timestamps
    end
  end
end
