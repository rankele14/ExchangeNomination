class University < ApplicationRecord
	validates :university_name, presence: true
end
