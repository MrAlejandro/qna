FactoryBot.define do
  sequence(:reward_name) { |n| "Reward name #{n}" }

  factory :reward do
    name { generate(:reward_name) }
    image { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'image.png'), 'reward.png') }
  end
end
