FactoryBot.define do
  sequence(:answer_body) { |n| "Answer body #{n}" }

  factory :answer do
    body { generate(:answer_body) }
    question
    association :author, factory: :user
    best { false }

    trait :with_files do
      files do
        [
            fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb'),
            fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'), 'rails_helper.rb'),
        ]
      end
    end

    trait :invalid do
      body { nil }
    end
  end
end
