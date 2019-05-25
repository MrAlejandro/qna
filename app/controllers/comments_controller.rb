class CommentsController < ApplicationController
  before_action :set_commentable, only: :create
  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.author = current_user
    @comment.save
  end

  private

  def set_commentable
    resource, id = request.path.split('/')[1, 2]
    resource_kalss = resource.singularize.classify.constantize
    @commentable = resource_kalss.find(id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        broadcasting,
        ApplicationController.render(partial: 'comments/comment.json', locals: { comment: @comment })
    )
  end

  def broadcasting
    "#{params['stream_resource']}_#{params['stream_resource_id']}_comments"
  end
end
