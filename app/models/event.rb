class Event < ApplicationRecord
  belongs_to :apocalypse

  validates :name, :description, :base_success_chance, :reward, :consequence, presence: true
  validates :base_success_chance, inclusion: 0..100

  def success_chance(pet)
    # Start with the base success chance
    chance = base_success_chance
    puts chance
    if pet.pet_buffs.any?
      pet.buffs.each do |buff|
        chance += buff.points[:success_rate] * 100
      end
    end

    if pet.pet_moods.any?
      pet.moods.each do |mood|
        chance += mood.success_modifier * 100
      end
    end

    if pet.user.user_buffs.any?
      pet.user.buffs.each do |buff|
        chance += buff.points[:success_rate] * 100
      end
    end

    # Modify chance based on pet stats
    chance += success_modifier_by_stats["agility"] * pet.agility
    chance += success_modifier_by_stats["strength"] * pet.strength
    chance += success_modifier_by_stats["intelligence"] * pet.intelligence

    # Ensure the chance is within reasonable bounds (e.g., 0% to 100%)
    chance = [ [ chance, 100 ].min, 0 ].max

    chance.round(2) # Return a rounded percentage
  end

  def process_event(pet)
    success_chance(pet)
    process_outcome(pet)
  end

  # Process the outcome of the event
  def process_outcome(pet)
    if rand(100) < success_chance(pet)
      pet.gain_experience(50)
      pet.update_stats_from_event_success
      "Success! #{reward}"
    else
      pet.update_stats_from_event_failure
      pet.gain_experience(25)
      "Failure... #{consequence}"
    end
  end
end
