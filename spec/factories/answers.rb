FactoryBot.define do
  factory :answer do
    body { 'My Answer' }
    question { create(:question) }
    author { create(:user) }

    trait :invalid do
      body { nil }
    end
  end
end
