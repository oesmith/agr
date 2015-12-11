class CreateStreams < ActiveRecord::Migration
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
