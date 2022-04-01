class Authorized < ApplicationRecord
    validates :authorized_email, presence: true
end
