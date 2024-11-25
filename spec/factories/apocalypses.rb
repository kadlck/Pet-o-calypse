FactoryBot.define do
  factory :apocalypse do
    name { "Zombie Apocalypse" }
    description { "The dead rise from their graves, wreaking havoc on the living." }
    association :pet
  end
end
