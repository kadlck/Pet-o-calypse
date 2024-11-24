class CreateApocalypses < ActiveRecord::Migration[8.0]
  def change
    create_table :apocalypses do |t|
      t.references :pet, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :twist
      t.string :main_threat

      t.timestamps
    end
  end
end
