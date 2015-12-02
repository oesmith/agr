class CreateTrains < ActiveRecord::Migration
  def change
    create_table :trains do |t|
      t.string :from
      t.string :to
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
