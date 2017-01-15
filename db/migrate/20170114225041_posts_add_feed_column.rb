class PostsAddFeedColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :feed_id, :integer
  end
end
