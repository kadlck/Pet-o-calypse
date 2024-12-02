class RandomEventJob < ApplicationJob
  queue_as :default

  def perform
    Pet.find_each do |pet|
      next if pet.retired? || pet.apocalypse_ready?

      # Apply a random mood
      mood = Pet.load_moods.sample
      pet.apply_mood(mood["name"]) if mood
    end
  end
end
