class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User"

  validates :body, presence: true

  def author?(user)
    user && author.id == user.id
  end
end
