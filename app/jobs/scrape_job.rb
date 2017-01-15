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
        Post.create(
          user: scrape.user,
          scrape: scrape,
          feed: feed,
          title: entry.title.content,
          published_at: entry.published.content,
          content: entry.content.content,
          link: entry.link.href # TODO(olly): handle multiple links.
        )
      end
    end

    def scrape_rss(scrape, feed, rss)
      rss.channel.items.each do |item|
        Post.create(
          user: scrape.user,
          scrape: scrape,
          feed: feed,
          title: item.title,
          published_at: item.pubDate,
          content: item.content_encoded || item.description,
          link: item.link
        )
      end
    end
end
