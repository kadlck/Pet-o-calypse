class CreateApocalypses < ActiveRecord::Migration[8.0]
  def change
    create_table :apocalypses do |t|
      t.string :name
      t.text :description
      t.string :twist
      t.string :main_threat

      t.timestamps
    end
  end
end
