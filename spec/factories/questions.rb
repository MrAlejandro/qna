FactoryBot.define do
  sequence(:question_title) { |n| "Question title #{n}" }
  sequence(:question_body) { |n| "Question body #{n}" }

  factory :question do
    title { generate(:question_title) }
    body { generate(:question_body) }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end
  end

  factory :question_with_answers, parent: :question do
    after :create do |question|
      question.answers = create_list(:answer, 3)
    end
  end
end
