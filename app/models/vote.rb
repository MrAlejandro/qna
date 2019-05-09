class Vote < ApplicationRecord
  VOTE_CODE_UP = 1
  VOTE_CODE_DOWN = -1

  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, presence: true, uniqueness: { scope: [:user_id, :votable_id] }
  validates_inclusion_of :value, in: [VOTE_CODE_UP, VOTE_CODE_DOWN]
end
