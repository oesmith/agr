class ScrapeError < ApplicationRecord
  belongs_to :scrape
  belongs_to :feed
end
