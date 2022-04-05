class Response < ApplicationRecord
	belongs_to :student
	belongs to :question
	validates :reply, :question_id, presence: true
end
