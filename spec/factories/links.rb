FactoryBot.define do
  sequence(:link_name) { |n| "Link name #{n}" }

  factory :link do
    name { generate(:link_name) }
    url
  end
end
