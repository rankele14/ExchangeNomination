class AddRepresentativeIdToStudents < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :representative_id, :integer
  end
end
