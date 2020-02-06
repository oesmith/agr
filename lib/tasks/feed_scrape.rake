namespace :feed do
  desc "Scrape new posts in feeds"
  task scrape: :environment do
    ScrapeJob.perform_now()
  end
end
