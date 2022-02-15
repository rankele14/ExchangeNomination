class AddRepEmailToRepresentatives < ActiveRecord::Migration[6.1]
  def change
    add_column :representatives, :rep_email, :string
  end
end
