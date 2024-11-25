FactoryBot.define do
  factory :event do
    name { "AI Control System Hack" }
    description { "The pet must regain control over the rogue AI." }
    base_success_chance { 60 }
    success_modifier_by_stats { { agility: 0.1, strength: 0.2, intelligence: 0.4 } }
    reward { "Access to secret files" }
    consequence { "AI counterattack, system damage" }
    association :apocalypse
  end
end
