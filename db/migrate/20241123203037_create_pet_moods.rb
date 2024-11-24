class CreatePetMoods < ActiveRecord::Migration[8.0]
  def change
    create_table :pet_moods do |t|
      t.references :pet, null: false, foreign_key: true
      t.string :name
      t.string :effect
      t.text :description
      t.text :points
      t.integer :duration

      t.timestamps
    end
  end
end
