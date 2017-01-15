class Scrape < ApplicationRecord
  belongs_to :user
  has_many :posts
  enum state: [:pending, :complete, :errors]
end
