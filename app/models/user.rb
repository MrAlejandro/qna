class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github]

  has_many :questions, foreign_key: :author_id
  has_many :comments, foreign_key: :author_id
  has_many :answers, foreign_key: :author_id
  has_many :authorizations, dependent: :destroy
  has_many :rewards

  def author_of?(resource)
    id == resource.author_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end
end
