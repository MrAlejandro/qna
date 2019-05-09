module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def upvote(user)
    vote(user, Vote::VOTE_CODE_UP)
  end

  def downvote(user)
    vote(user, Vote::VOTE_CODE_DOWN)
  end

  def rating
    upvotes.count - downvotes.count
  end

  def upvotes
    votes.where(vote: Vote::VOTE_CODE_UP)
  end

  def downvotes
    votes.where(vote: Vote::VOTE_CODE_DOWN)
  end

  private

  def vote(user, vote)
    if votes.where(user: user, vote: vote).present?
      delete_user_vote!(user)
    else
      transaction do
        delete_user_vote!(user)
        votes.create!(user: user, vote: vote)
      end
    end
  end

  def delete_user_vote!(user)
    user_votes(user).delete_all
  end

  def user_votes(user)
    votes.where(user: user)
  end
end
