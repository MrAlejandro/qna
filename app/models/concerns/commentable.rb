module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, dependent: :destroy, as: :commentable
  end

  def comment(user, comment_params)
    comments.create(author: user, body: comment_params[:body])
  end
end
