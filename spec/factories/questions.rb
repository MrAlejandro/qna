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

    trait :with_files do
      files do
        [
          fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb'),
          fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'), 'rails_helper.rb'),
        ]
      end
    end
  end

  factory :question_with_answers, parent: :question do
    after :create do |question|
      question.answers = create_list(:answer, 3)
    end
  end

  factory :question_with_links, parent: :question do
    after :create do |question|
      question.links = create_list(:link, 3, linkable: question)
    end
  end
end
