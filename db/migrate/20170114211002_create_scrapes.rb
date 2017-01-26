class CreateScrapes < ActiveRecord::Migration[5.0]
  def change
    create_table :scrapes do |t|
      t.integer :user_id
      t.integer :state

      t.timestamps
    end
  end
end