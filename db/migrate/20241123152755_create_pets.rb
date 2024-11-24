class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :species
      t.string :description
      t.string :class_name
      t.string :twist
      t.integer :hunger_level, default: 50
      t.integer :happiness, default: 50
      t.integer :health, default: 50
      t.integer :intelligence, default: 5
      t.integer :agility, default: 5
      t.integer :strength, default: 5
      t.integer :experience, default: 0
      t.integer :level, default: 1

      t.text :abilities_level_unlocked
      t.text :history_unlocked

      t.string :mood
      t.integer :feud
      t.boolean :retired, default: false
      t.boolean :apocalypse_ready, default: false

      t.timestamps
    end
  end
end
