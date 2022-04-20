# frozen_string_literal: true

class CreateVariables < ActiveRecord::Migration[6.1]
  def change
    create_table :variables do |t|
      t.string :var_name
      t.string :var_value

      t.timestamps
    end
  end
end
