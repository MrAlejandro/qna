FactoryBot.define do
  sequence(:email) { |n| "email#{n}@example.com" }
  sequence(:url) { |n| "http://example#{n}.com" }
end
