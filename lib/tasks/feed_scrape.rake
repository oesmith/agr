namespace :feed do
  desc "Scrape new posts in feeds"
  task scrape: :environment do
    Feed.distinct.pluck(:user_id).each do |user_id|
      scrape = Scrape.create(user: User.find(user_id), state: "pending")
      ScrapeJob.perform_now(scrape)
    end
  end
end
