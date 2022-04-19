class CreateNominators < ActiveRecord::Migration[6.1]
  def change
    create_table :nominators do |t|
      t.string :first_name
      t.string :last_name
      t.string :title
      t.integer :university_id
      t.string :nominator_email

      t.timestamps
    end
  end
end
