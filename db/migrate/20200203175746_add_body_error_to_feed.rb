class AddBodyErrorToFeed < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :articles_json, :binary
    add_column :feeds, :error_text, :text
  end
end
