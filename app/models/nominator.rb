# frozen_string_literal: true

class Nominator < ApplicationRecord
  validates :first_name, :last_name, :title, :nominator_email, presence: true
  validates :nominator_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_many :students, dependent: :destroy
  belongs_to :university
end
