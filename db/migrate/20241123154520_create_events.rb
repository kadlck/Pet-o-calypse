class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.text :description
      t.integer :success_chance
      t.references :apocalypse, null: false, foreign_key: true
      t.string :name
      t.integer :base_success_chance
      t.text :reward
      t.text :consequence
      t.json :success_modifier_by_stats, default: { agility: 0, strength: 0, intelligence: 0 }
      t.timestamps
    end
  end
end
