FactoryBot.define do
  factory :pet do
    name { Faker::Creature::Animal.name }
    species { [ "dog_wizard", "rabbit_necromancer" ].sample }
    health { 100 }
    hunger_level { 50 }
    association :user # Links this pet to a user
  end
end
