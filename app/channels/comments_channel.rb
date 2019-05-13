class CommentsChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "#{params['resource']}_#{params['id']}_comments"
  end
end
