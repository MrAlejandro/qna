class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy
  belongs_to :author, class_name: 'User'

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, presence: true
end
