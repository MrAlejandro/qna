FactoryBot.define do
  sequence :email do |n|
    "email#{n}@example.com"
  end
  sequence :title do |n|
    "Title #{n}"
  end
  sequence :body do |n|
    "Body #{n}"
  end
end
