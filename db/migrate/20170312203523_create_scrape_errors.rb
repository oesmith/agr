class CreateScrapeErrors < ActiveRecord::Migration[5.0]
  def change
    create_table :scrape_errors do |t|
      t.integer :scrape_id
      t.integer :feed_id
      t.text :error_text

      t.timestamps
    end
  end
end
