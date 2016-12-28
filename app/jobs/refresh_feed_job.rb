class RefreshFeedJob < ApplicationJob
  queue_as :default

  def perform(feed)
    feed.refresh
    feed.save
  end
end
