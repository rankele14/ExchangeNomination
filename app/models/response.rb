class Response < ApplicationRecord
	belongs_to :student
	validates :reply, :question_id, presence: true
end
