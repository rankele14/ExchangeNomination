class University < ApplicationRecord
    validates :university_name, :num_nominees, :max_limit, presence: true
    has_many :students, dependent: :destroy
    has_many :nominators, dependent: :destroy
end
