class Variable < ApplicationRecord
    validates :var_name, :var_value, presence: true
end
