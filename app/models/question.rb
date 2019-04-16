class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: "User"

  validates :title, :body, presence: true

  def author?(user)
    user && author.id == user.id
  end
end
