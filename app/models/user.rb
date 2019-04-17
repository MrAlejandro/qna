class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, foreign_key: :author_id
  has_many :answers, foreign_key: :author_id

  def author?(resource)
    id == resource.author_id
  end
end
