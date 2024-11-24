class CreateRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :rewards do |t|
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.text :secrets_rewards
      t.text :accomplisments

      t.timestamps
    end
  end
end
