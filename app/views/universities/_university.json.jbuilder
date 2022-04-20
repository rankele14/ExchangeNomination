# frozen_string_literal: true

json.extract!(university, :id, :university_name, :num_nominees, :created_at, :updated_at)
json.url(university_url(university, format: :json))
