class PostAddUidColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :uid, :text
    Post.destroy_all # This is all ephemeral data anyway..
    add_index :posts, [:uid, :feed_id, :user_id], unique: true
  end
end
