class Apocalypse < ApplicationRecord
  has_many :events, dependent: :destroy
  has_many :minigames

  validates :name, presence: true

  def self.decide_for_pet(pet)
    return pet.apocalypse if pet.apocalypse.present? # Avoid re-deciding if already set

    apocalypse_data = load_apocalypse_encounters
    species_data = apocalypse_data.find { |entry| entry["pet"] == pet.species }

    return nil unless species_data # No data for this species

    # Weighted random selection
    total_chance = species_data["encounters"].sum { |enc| enc["chance"] }
    random_pick = rand(total_chance)

    cumulative = 0
    chosen_apocalypse = nil

    species_data["encounters"].each do |encounter|
      cumulative += encounter["chance"]
      if random_pick < cumulative
        chosen_apocalypse = encounter["apocalypse"]
        break
      end
    end

    # Create and return the apocalypse record
    create(pet: pet, name: chosen_apocalypse)
  end

  def self.load_apocalypse_encounters
    YAML.load_file(Rails.root.join("config", "gameplan", "Apocalypse", "apocalypse_encounters.yml"))
  end
end
