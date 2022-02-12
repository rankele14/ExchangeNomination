class AddExchangeTermToStudents < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :exchange_term, :string
  end
end
