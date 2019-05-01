FactoryBot.define do
  sequence(:answer_body) { |n| "Answer body #{n}" }

  factory :answer do
    body { generate(:answer_body) }
    question
    association :author, factory: :user
    best { false }

    trait :invalid do
      body { nil }
    end
  end
end
