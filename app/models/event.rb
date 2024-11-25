class Event < ApplicationRecord
  belongs_to :apocalypse

  validates :name, :description, :base_success_chance, :reward, :consequence, presence: true
  validates :base_success_chance, inclusion: 0..100

  def success_chance(pet)
    # Start with the base success chance
    chance = base_success_chance

    # Apply pet's active buffs
    pet.active_buffs.each do |buff|
      chance += buff.points[:success_rate] * 100 # Convert modifier to percentage
    end

    # Apply pet's active moods (if moods influence success)
    pet.active_moods.each do |mood|
      chance += mood.success_modifier * 100
    end

    # Apply user's active buffs
    pet.user.active_buffs.each do |buff|
      chance += buff.points[:success_rate] * 100
    end

    # Modify chance based on pet stats
    chance += agility_modifier * pet.agility
    chance += strength_modifier * pet.strength
    chance += intelligence_modifier * pet.intelligence

    # Ensure the chance is within reasonable bounds (e.g., 0% to 100%)
    chance = [ [ chance, 100 ].min, 0 ].max

    chance.round(2) # Return a rounded percentage
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
