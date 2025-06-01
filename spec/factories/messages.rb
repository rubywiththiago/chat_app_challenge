FactoryBot.define do
  factory :message do
    text { "Hello World" }
    association :user
  end
end
