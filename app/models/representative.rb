class Representative < ApplicationRecord
    validates :first_name, :last_name, :title, :university_id, :rep_email, presence: true
    validates :rep_email, format: { with: URI::MailTo::EMAIL_REGEXP }
    has_many :students, dependent: :destroy
    belongs_to :university
end
