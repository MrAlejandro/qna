FactoryBot.define do
  factory :user do
    email
    password { 'secret' }
    password_confirmation { 'secret' }
  end
end
