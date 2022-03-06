class CreateRepresentatives < ActiveRecord::Migration[6.1]
  def change
    create_table :representatives do |t|
      t.string :first_name
      t.string :last_name
      t.string :title
      t.integer :university_id
      t.string :rep_email

      t.timestamps
    end
  end
end
