# frozen_string_literal: true

json.array!(@authorizeds, partial: 'authorizeds/authorized', as: :authorized)
