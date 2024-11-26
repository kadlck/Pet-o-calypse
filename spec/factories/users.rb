FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Name.name }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
