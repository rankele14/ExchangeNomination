# frozen_string_literal: true

json.extract! authorized, :id, :authorized_email, :created_at, :updated_at
json.url authorized_url(authorized, format: :json)
