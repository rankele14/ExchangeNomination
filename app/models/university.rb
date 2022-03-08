class University < ApplicationRecord
    validates :university_name, presence: true
    has_many :students, dependent: :destroy
    has_many :representatives, dependent: :destroy
end
