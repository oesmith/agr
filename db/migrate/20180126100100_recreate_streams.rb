class RecreateStreams < ActiveRecord::Migration[5.0]
  def change
    create_table :streams do |t|
      t.integer :user_id, null: false
      t.string :type, null: false
      t.string :remote_id, null: false

      t.text :config, null: false
      t.text :profile
      t.text :stream

      t.timestamps null: false
    end
  end
end