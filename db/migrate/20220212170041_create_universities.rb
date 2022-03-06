class CreateUniversities < ActiveRecord::Migration[6.1]
  def change
    create_table :universities do |t|
      t.string :university_name
      t.integer :num_nominees, default: 0

      t.timestamps
    end
  end
end
