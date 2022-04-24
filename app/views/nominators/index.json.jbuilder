# frozen_string_literal: true

json.array!(@nominators, partial: 'nominators/nominator', as: :nominator)
