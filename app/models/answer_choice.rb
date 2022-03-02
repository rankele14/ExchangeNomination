class AnswerChoice < ApplicationRecord
	validates :questionID, :answer_choice, presence: true
end
