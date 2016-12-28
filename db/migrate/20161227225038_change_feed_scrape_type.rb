class ChangeFeedScrapeType < ActiveRecord::Migration[5.0]
  def change
    change_column :feeds, :scrape, :binary
  end
end
