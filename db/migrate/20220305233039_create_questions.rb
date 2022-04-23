# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.boolean :multi
      t.string :prompt

      t.timestamps
    end
  end
end
