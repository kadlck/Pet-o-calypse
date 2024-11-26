FactoryBot.define do
  factory :pet do
    name { Faker::Creature::Animal.name }
    species { [ "hamster_assassin", "rabbit_necromancer" ].sample }
    health { 100 }
    hunger_level { 50 }
    association :user # Links this pet to a user
  end
end
