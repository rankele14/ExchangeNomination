class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.boolean :multiple_choice
      t.string :prompt

      t.timestamps
    end
  end
end
