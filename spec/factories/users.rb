FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Internet.unique.username(specifier: 5..10) }
    email { Faker::Internet.unique.email }
    password { "a" * 20 }
    confirmed_at { Time.now }
  end
end
