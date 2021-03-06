FactoryBot.define do
  sequence(:comment_body) { |n| "Comment body #{n}" }

  factory :comment do
    body { generate(:comment_body) }
  end

  trait :invalid do
    body { nil }
  end
end
