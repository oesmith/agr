class Post < ApplicationRecord
  belongs_to :scrape
  belongs_to :user
  belongs_to :feed
  default_scope { order(published_at: :desc) }
end
