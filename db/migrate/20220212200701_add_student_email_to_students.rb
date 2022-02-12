class AddStudentEmailToStudents < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :student_email, :string
  end
end
