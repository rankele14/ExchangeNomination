class AddNumNomineesToUniversities < ActiveRecord::Migration[6.1]
  def change
    add_column :universities, :num_nominees, :int
    #change_column_default :universities, :num_nominees, from: true, to: false
    change_column :universities, :num_nominees, :integer, default: 0
  end
end
