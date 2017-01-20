class Scrape < ApplicationRecord
  belongs_to :user
  has_many :posts
  enum state: [:pending, :complete, :errors]

  def previous
    @previous ||= self.class.where("user_id = ? and created_at < ?", user_id, created_at).order(created_at: :desc).first
  end
end
