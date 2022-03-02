class CreateStudentResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :student_responses do |t|
      t.integer :questionID
      t.integer :studentID
      t.string :response

      t.timestamps
    end
  end
end
