FactoryBot.define do
  factory :question do
    title
    body
    author { create(:user) }

    trait :invalid do
      title { nil }
    end
  end

  factory :question_with_answers, parent: :question do
    after :create do |question|
      create_list :answer, 3, question: question
    end
  end
end
