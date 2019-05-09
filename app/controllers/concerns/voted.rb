module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: %i[upvote downvote]
  end

  def upvote
    @resource.upvote(current_user) if !current_user.author_of?(@resource)

    respond_to do |format|
      format.json { render json: { rating: @resource.rating } }
    end
  end

  def downvote
    @resource.downvote(current_user) if !current_user.author_of?(@resource)

    respond_to do |format|
      format.json { render json: { rating: @resource.rating } }
    end
  end

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end
end
