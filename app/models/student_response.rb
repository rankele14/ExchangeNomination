class StudentResponse < ApplicationRecord
	validates :questionID,  :studentID,  :response, presence: true
end
