class Apocalypse < ApplicationRecord
  belongs_to :pet
  has_many :events, dependent: :destroy
  has_many :minigames

  validates :name, presence: true

  def self.decide_for_pet(pet)
    return pet.apocalypse if pet.apocalypse.present? # Avoid re-deciding if already set

    apocalypse_data = load_apocalypse_encounters
    species_data = apocalypse_data["apocalypse_encounters"].find { |entry| entry["pet"] == pet.species }

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

    chosen_apocalypse_data = load_apocalypses["apocalypses"][chosen_apocalypse]

    create(
      pet: pet,
      name: chosen_apocalypse,
      description: chosen_apocalypse_data["description"],
      main_threat: chosen_apocalypse_data["main_threat"],
      twist: chosen_apocalypse_data["twist"]
    )
  end

  def self.load_apocalypse_encounters
    YAML.load_file(Rails.root.join("config", "gameplan", "Apocalypse", "apocalypse_encounters.yml"))
  end

  def self.load_apocalypses
    YAML.load_file(Rails.root.join("config", "gameplan", "Apocalypse", "apocalypses.yml"))
  end

  after_create :assign_events, if: -> { name.present? }


  private

  def assign_events
    event_pool = load_apocalypse_events
    selected_events = event_pool["events"].sample(10) # Pick 10 random events

    selected_events.each do |event_data|
      events.create!(
        name: event_data["name"],
        description: event_data["description"],
        base_success_chance: event_data["base_success_chance"],
        success_modifier_by_stats: { agility: event_data["success_modifier_by_stats"]["agility"],
                                     strength: event_data["success_modifier_by_stats"]["strength"],
                                     intelligence: event_data["success_modifier_by_stats"]["intelligence"] },
        reward: event_data["reward"],
        consequence: event_data["consequence"]
      )
    end
  end

  def load_apocalypse_events
    file_path = Rails.root.join("config", "gameplan", "Events", "events_#{name}.yml")
    YAML.load_file(file_path)
  end
end
