# frozen_string_literal: true

class Authorized < ApplicationRecord
  validates :authorized_email, presence: true
  validates :authorized_email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
