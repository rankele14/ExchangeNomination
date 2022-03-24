class Question < ApplicationRecord
	has_many :answer , dependent: :destroy
	validates :prompt, presence: true
end
