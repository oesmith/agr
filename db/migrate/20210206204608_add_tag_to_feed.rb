class AddTagToFeed < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :tag, :string
  end
end
