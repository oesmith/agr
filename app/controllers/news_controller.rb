class NewsController < ApplicationController
  def index
    @feeds = Feed.where(user_id: current_user)
    @articles = @feeds
      .select(&:has_articles?)
      .flat_map(&:articles)
      .sort_by(&:published_at)
      .reverse
      .first(50)
  end

  private

  def parse_feed(feed)
    return [] if feed.body_text.nil?
    rss = RSS::Parser.parse(feed.body_text)
    case "#{rss.feed_type}/#{rss.feed_version}"
    when "atom/1.0"
      parse_atom(feed, rss)
    when "rss/2.0"
      parse_rss(feed, rss)
    else
      []
    end
  end

  def parse_atom(feed, rss)
    rss.entries.map do |entry|
      Article.new(
        feed: feed,
        published_at: (entry.published || entry.updated).content,
        title: entry.title.content,
        content: entry.content.content,
        link: entry.link.href,
      )
    end
  end

  def parse_rss(feed, rss)
    rss.channel.items.map do |item|
      Article.new(
        feed: feed,
        published_at: item.pubDate,
        title: item.title,
        content: item.content_encoded || item.description,
        link: item.link,
      )
    end
  end
end
