# frozen_string_literal: true

class CreateAuthorizeds < ActiveRecord::Migration[6.1]
  def change
    create_table :authorizeds do |t|
      t.string :authorized_email

      t.timestamps
    end
  end
end
