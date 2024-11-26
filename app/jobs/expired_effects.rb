class RemoveExpiredEffects < ApplicationJob
  queue_as :default

  def perform(pet_id)
    pet = Pet.find_by(id: pet_id)
    return unless pet

    # Remove expired buffs
    pet.pet_buffs.each do |buff|
      if buff.expired?
        pet.remove_buff_effect(buff)
        buff.destroy
      end
    end

    # Remove expired moods
    pet.pet_moods.each do |mood|
      if mood.expired?
        pet.remove_mood_effect(mood)
        mood.destroy
      end
    end
  end
end
