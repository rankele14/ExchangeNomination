# frozen_string_literal: true

json.array! @representatives, partial: 'representatives/representative', as: :representative
