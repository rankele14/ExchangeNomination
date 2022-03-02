class CreateAnswerChoices < ActiveRecord::Migration[6.1]
  def change
    create_table :answer_choices do |t|
      t.integer :questionID
      t.string :answer_choice

      t.timestamps
    end
  end
end
