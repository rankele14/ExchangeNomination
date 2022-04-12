class Question < ApplicationRecord
	has_many :answer, dependent: :destroy
	has_many :response, dependent: :destroy
	validates :prompt, presence: true
end
