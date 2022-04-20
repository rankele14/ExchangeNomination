# frozen_string_literal: true

class Response < ApplicationRecord
  belongs_to :student
  validates :question_id, presence: true
end
