class FeedAddUserColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :feeds, :user_id, :integer
  end
end
