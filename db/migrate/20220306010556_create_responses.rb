# frozen_string_literal: true

class CreateResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :responses do |t|
      t.string :reply
      t.integer :question_id
      t.references :student

      t.timestamps
    end
  end
end
