class DropScrapes < ActiveRecord::Migration[5.2]
  def change
    drop_table :posts
    drop_table :scrape_errors
    drop_table :scrapes
  end
end
