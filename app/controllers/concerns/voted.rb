module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[upvote downvote]
  end

  def upvote
    @votable.upvote(current_user) if !current_user.author_of?(@votable)

    respond_to do |format|
      format.json { render json: { rating: @votable.rating } }
    end
  end

  def downvote
    @votable.downvote(current_user) if !current_user.author_of?(@votable)

    respond_to do |format|
      format.json { render json: { rating: @votable.rating } }
    end
  end

  private

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end
