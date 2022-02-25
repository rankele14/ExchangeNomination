class Representative < ApplicationRecord
    validates :first_name, :last_name, :title, :university_id, :rep_email, presence: true
    has_many :students, dependent: :destroy
    belongs_to :university
end
