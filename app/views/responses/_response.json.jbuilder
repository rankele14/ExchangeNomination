# frozen_string_literal: true

json.extract!(response, :id, :reply, :question, :student, :created_at, :updated_at)
json.url(response_url(response, format: :json))
