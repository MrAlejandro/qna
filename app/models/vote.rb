class Vote < ApplicationRecord
  VOTE_CODE_UP = 'up'
  VOTE_CODE_DOWN = 'down'

  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :vote, presence: true
end
