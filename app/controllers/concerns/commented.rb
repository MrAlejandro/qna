module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[comment]
    after_action :publish_comment, only: %i[comment]
  end

  def comment
    @comment = @commentable.comment(current_user, comment_params)
  end

  private

  def set_commentable
    @commentable = controller_name.classify.constantize.find(params[:id])
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
    "#{@commentable.class.to_s.underscore}_#{@commentable.id}_comments"
  end
end
