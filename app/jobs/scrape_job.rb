class ScrapeJob < ApplicationJob
  queue_as :default

  def perform()
    Feed.all.each(&:refresh)
  end
end
