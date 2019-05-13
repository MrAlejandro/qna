json.extract! answer, :id, :body, :question_id, :author_id, :best, :rating, :question

json.upvote_link upvote_link(answer)
json.downvote_link downvote_link(answer)
json.resource_klass 'Answer'

json.files answer.files do |file|
  json.file_name file.filename
  json.file_path url_for(file)
end

json.links answer.links do |link|
  json.name link.name
  json.url link.url
end
