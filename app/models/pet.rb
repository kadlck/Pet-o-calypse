class Pet < ApplicationRecord
  belongs_to :user
  has_many :pet_buffs, dependent: :destroy
  has_many :pet_moods, dependent: :destroy
  has_one :apocalypse, dependent: :destroy
  serialize :history_unlocked, Array


  # Validations
  validates :name, presence: true
  validates :species, presence: true

  # Set default attributes when creating a pet
  after_initialize :set_defaults, if: :new_record?

  # Load all pet data from YAML
  def self.load_all_pets
    pet_file = Rails.root.join("config", "gameplan", "pets", "pets.yml")
    YAML.load_file(pet_file)["pets"]
  end

  def self.load_buffs
    buff_file = Rails.root.join("config", "gameplan", "Pets", "pet_buffs.yml")
    YAML.load_file(buff_file)["buffs"]
  end

  def self.load_moods
    mood_file = Rails.root.join("config", "gameplan", "Pets", "pet_moods.yml")
    YAML.load_file(mood_file)["moods"]
  end

  def self.load_pet_histories
    history_file = Rails.root.join("config", "gameplan", "pets", "pet_histories.yml")
    YAML.load_file(history_file)["pets"]
  end

  # Set default stats and abilities from the YAML data
  after_create :set_default_stats_and_abilities



  def apply_buff(buff_name)
    buff_data = Pet.load_buffs.find { |b| b["name"] == buff_name }
    return unless buff_data

    applied_buff = pet_buffs.create!(
      name: buff_data["name"],
      effect: buff_data["effect"],
      description: buff_data["description"],
      duration: parse_duration(buff_data["duration"]),
      points: buff_data["points"]
    )

    applied_buff.apply_effect
    applied_buff
  end

  # Apply a mood by name
  def apply_mood(mood_name)
    mood_data = Pet.load_moods.find { |m| m["name"] == mood_name }
    return unless mood_data

    applied_mood = pet_moods.create!(
      name: mood_data["name"],
      effect: mood_data["effect"],
      description: mood_data["description"],
      duration: parse_duration(mood_data["duration"]),
      points: mood_data["points"]
    )

    applied_mood.apply_effect
    applied_mood
  end

  # Handle expiration or one-time buffs
  def remove_expired_buffs
    pet_buffs.each do |buff|
      if buff.duration.is_a?(Numeric) && buff.duration <= 0
        buff.remove_effect
        buff.destroy
      end
    end
  end

  # Remove expired moods
  def remove_expired_moods
    pet_moods.each do |mood|
      if mood.duration.is_a?(Numeric) && mood.duration <= 0
        mood.remove_effect
        mood.destroy
      end
    end
  end


  def unlocked_backstories
    pet_histories = Pet.load_pet_histories[species]["backstory"]
    history_unlocked.map { |key| pet_histories[key] }.compact
  end

  # Unlock the next backstory (incrementally)
  def unlock_next_history
    pet_histories = Pet.load_pet_histories[species]["backstory"]
    all_keys = pet_histories.keys.sort
    next_key = (all_keys - history_unlocked).first

    if next_key
      history_unlocked << next_key
      save
      pet_histories[next_key]
    else
      nil # No more histories to unlock
    end
  end

  private

  def set_default_stats_and_abilities
    # Fetch pet data based on the species
    pet_data = Pet.load_all_pets[species]

    # Set base stats
    self.agility = pet_data["base_stats"]["agility"]
    self.strength = pet_data["base_stats"]["strength"]
    self.intelligence = pet_data["base_stats"]["intelligence"]

    # Set initial description, twist, and class
    self.description = pet_data["description"]
    self.twist = pet_data["twist"]
    self.class_name = pet_data["class"]

    self.levels = pet_data["levels"]
    save
  end

  def set_defaults
    # Initial defaults for all pets
    self.hunger_level ||= 50
    self.happiness ||= 50
    self.health ||= 50
    self.apocalypse_ready ||= false
    self.retired ||= false
    self.feud ||= nil # Feud can be dynamically assigned later
    self.experince = 0
    self.history_unlocked ||= []
    self.abilities_level_unlocked = []
    self.mood ||= []
    self.pet_buffs = []
  end

  def parse_duration(duration)
    case duration
    when "next_event"
      -1 # Special value for handling in the event system
    else
      duration.to_i # Convert to integer for time-based durations
    end
  end

  def trigger_apocalypse
    return apocalypse if apocalypse.present?
    Apocalypse.decide_for_pet(self)
  end
end
