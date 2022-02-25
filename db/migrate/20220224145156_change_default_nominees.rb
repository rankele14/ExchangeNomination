class ChangeDefaultNominees < ActiveRecord::Migration[6.1]
  def change
    change_column :universities, :num_nominees, :integer, default: 0
  end
end
