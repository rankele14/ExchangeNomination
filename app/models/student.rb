class Student < ApplicationRecord
	has_many :response , dependent: :destroy
    validates :first_name, :last_name, :university_id, :student_email, :exchange_term, :degree_level, :major, presence: true
end
