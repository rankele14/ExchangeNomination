# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :choice
      t.references :question

      t.timestamps
    end
  end
end
