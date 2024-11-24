class CreateMiniGames < ActiveRecord::Migration[8.0]
  def change
    create_table :mini_games do |t|
      t.string :name
      t.text :description
      t.integer :base_success_rate, default: 0
      t.references :apocalypse, null: false, foreign_key: true

      t.timestamps
    end
  end
end
