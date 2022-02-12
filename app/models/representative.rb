class Representative < ApplicationRecord
    validates :first_name, :last_name, :title, :university_id, presence: true
end
