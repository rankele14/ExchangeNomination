class Student < ApplicationRecord
    validates :first_name, :last_name, :university_id, :student_email, :exchange_term, :degree_level, :major, presence: true
end
