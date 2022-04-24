# frozen_string_literal: true

class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.integer :university_id
      t.string :student_email
      t.string :exchange_term
      t.string :degree_level
      t.string :major
      t.integer :nominator_id

      t.timestamps
    end
  end
end
