class Answer < ApplicationRecord
  include Votable, Commentable

  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :author, class_name: "User"

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :body, presence: true

  scope :best_first, -> { order(best: :desc) }

  def mark_as_best!
    question_answers = question.answers

    Answer.transaction do
      question_answers.update_all(best: false)
      update!(best: true)
      question.reward.update!(user: author) if question.reward
    end
  end
end
