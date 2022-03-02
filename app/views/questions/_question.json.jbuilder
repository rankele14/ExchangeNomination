json.extract! question, :id, :multiple_choice, :prompt, :created_at, :updated_at
json.url question_url(question, format: :json)
