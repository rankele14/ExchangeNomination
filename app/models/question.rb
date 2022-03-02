class Question < ApplicationRecord
    validates :multiple_choice, :prompt, presence: true
    has_many :students, dependent: :destroy
end
