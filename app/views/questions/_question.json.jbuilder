json.extract! question, :id, :title, :body, :author_id, :rating

json.view_path question_path(question)
