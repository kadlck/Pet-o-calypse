class Event < ApplicationRecord
  belongs_to :apocalypse

  validates :name, :description, :base_success_chance, :reward, :consequence, presence: true
  validates :base_success_chance, inclusion: 0..100

  # Calculate success chance based on pet stats
  def success_chance(pet)
    base_success_chance
    # finish later
  end

  # Process the outcome of the event
  def process_outcome(pet)
    if rand(100) < success_chance(pet)
      pet.gain_experience(50)
      pet.update_stats_from_event_success
      "Success! #{reward}"
    else
      pet.update_stats_from_event_failure
      "Failure... #{consequence}"
    end
  end
end
