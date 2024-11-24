class PetBuff < ApplicationRecord
  belongs_to :pet

  # Apply the buff's effect to the pet
  def apply_effect
    points.each do |stat, value|
      adjust_stat(stat, value)
    end
  end

  # Remove the buff's effect from the pet
  def remove_effect
    points.each do |stat, value|
      adjust_stat(stat, -value)
    end
  end

  private

  def adjust_stat(stat, value)
    case stat
    when "agility"
      pet.agility += value
    when "intelligence"
      pet.intelligence += value
    when "success_rate"
      pet.success_chance_bonus ||= 0
      pet.success_chance_bonus += value
    when "strength"
      pet.strength += value
    end
    pet.save
  end
end
