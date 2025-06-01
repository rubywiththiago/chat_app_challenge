FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Internet.username(specifier: 5..10, separators: %w[- _]).gsub(/[^a-zA-Z0-9\-_]/, '') }
    email { Faker::Internet.unique.email }
    password { 'a' * 20 }
    confirmed_at { Time.now }
  end
end
