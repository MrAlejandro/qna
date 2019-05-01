class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User"

  has_many_attached :files

  validates :body, presence: true

  scope :best_first, -> { order(best: :desc) }

  def mark_as_best!
    question_answers = question.answers

    ActiveRecord::Base.transaction do
      question_answers.update_all(best: false)
      update!(best: true)
    end
  end
end
