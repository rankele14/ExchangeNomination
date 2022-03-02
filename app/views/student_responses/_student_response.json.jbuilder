json.extract! student_response, :id, :questionID, :studentID, :response, :created_at, :updated_at
json.url student_response_url(student_response, format: :json)
