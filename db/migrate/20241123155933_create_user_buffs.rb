class CreateUserBuffs < ActiveRecord::Migration[8.0]
  def change
    create_table :user_buffs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :effect
      t.integer :duration
      t.text :description
      t.text :points

      t.timestamps
    end
  end
end
