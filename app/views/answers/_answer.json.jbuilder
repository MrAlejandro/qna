json.extract! answer, :id, :body, :question_id, :author_id, :best, :rating, :question

json.answer_path answer_path(answer)
json.mark_as_best_path best_answer_path(answer)
json.upvote_link upvote_link(answer)
json.downvote_link downvote_link(answer)
json.resource_klass 'Answer'

json.files answer.files do |file|
  json.file_name file.filename
  json.file_path url_for(file)
  json.delete_file_path attachment_path(file, redirect_url: question_url(answer.question))
end

json.links answer.links do |link|
  json.name link.name
  json.url link.url
  json.delete_link_path link_path(link, redirect_url: question_url(answer.question))
end
