class ScrapeJob < ApplicationJob
  queue_as :default

  def perform(scrape)
    scrape.state = 'complete'
    Feed.where(user: scrape.user).each do |feed|
      begin
        scrape_feed(scrape, feed)
      rescue Exception => e
        logger.warn(e)
        scrape.state = 'errors'
      end
    end
    scrape.save
  end

  private

    def scrape_feed(scrape, feed)
      body = Net::HTTP.get(URI(feed.url))
      rss = RSS::Parser.parse(body)
      case "#{rss.feed_type}/#{rss.feed_version}"
      when "atom/1.0"
        scrape_atom(scrape, feed, rss)
      when "rss/2.0"
        scrape_rss(scrape, feed, rss)
      end
    end

    def scrape_atom(scrape, feed, rss)
      rss.entries.each do |entry|
        post = Post.find_or_initialize_by(
          user: scrape.user,
          feed: feed,
          uid: entry.id.content
        )
        post.title = entry.title.content
        post.published_at = entry.published.content
        post.content = entry.content.content
        post.link = entry.link.href # TODO(olly): handle multiple links.
        if post.changed?
          post.scrape = scrape
          post.save!
        end
      end
    end

    def scrape_rss(scrape, feed, rss)
      rss.channel.items.each do |item|
        post = Post.find_or_initialize_by(
          user: scrape.user,
          feed: feed,
          uid: item.guid.content
        )
        post.title = item.title
        post.published_at = item.pubDate
        post.content = item.content_encoded || item.description
        post.link = item.link
        if post.changed?
          post.scrape = scrape
          post.save!
        end
      end
    end
end
