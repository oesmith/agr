require "rss"
require "json"

class Feed < ActiveRecord::Base
  belongs_to :user

  ALTERNATE_TYPES = ["application/atom+xml", "application/rss+xml"]

  Article = Struct.new(
    :feed, :published_at, :title, :content, :link, keyword_init: true,
  )

  def refresh
    begin
      res = Net::HTTP.get_response(URI(url))
    rescue Exception => e
      update_error(e.to_s)
    else
      case res
      when Net::HTTPSuccess
        parse(res.body)
      when Net::HTTPMovedPermanently
        redirected(res["Location"])
      else
        update_error(res.to_s)
      end
    end
    save
  end

  def has_articles?
    !articles_json.nil?
  end

  def articles
    return nil if articles_json.nil?
    JSON.parse(articles_json).map do |article_hash|
      Article.new(article_hash.merge({ feed: self }))
    end
  end

  def self.resolve(url, redirects = 10)
    raise ArgumentError, "Too many redirects" if redirects == 0
    url = URI("http://#{url.to_s}") if url.scheme.nil?
    res = Net::HTTP.get_response(url)
    case res
    when Net::HTTPSuccess
      begin
        rss = RSS::Parser.parse(res.body)
      rescue
      end
      if rss.nil?
        # Attempt to find a link[rel=alternate] in the page.
        html = Nokogiri::HTML(res.body)
        alternate = html.css('link[rel="alternate"]').find do |e|
          e.attributes["type"] and ALTERNATE_TYPES.include? e.attributes["type"].value
        end
        raise "Unable to find a feed at #{url.to_s}" if alternate.nil?
        resolve(URI.join(url, alternate.attributes["href"].value), redirects - 1)
      else
        case "#{rss.feed_type}/#{rss.feed_version}"
        when "atom/1.0"
          Feed.new(url: url.to_s, name: rss.title.content)
        when "rss/2.0"
          Feed.new(url: url.to_s, name: rss.channel.title)
        else
          raise "Unsupported feed type #{rss.feed_type}/#{rss.feed_version}"
        end
      end
    when Net::HTTPRedirection
      # Follow redirects.
      resolve(URI.join(url, res["location"]), redirects - 1)
    else
      raise "HTTP fetch error (#{res.code})"
    end
  end

  private

  def parse(body)
    rss = RSS::Parser.parse(body)
    articles = case "#{rss.feed_type}/#{rss.feed_version}"
      when "atom/1.0" then parse_atom(rss)
      when "rss/2.0" then parse_rss(rss)
      else []
      end
    self.articles_json = articles.to_json
    self.error_text = nil
  end

  def parse_atom(rss)
    rss.entries.map do |entry|
      {
        published_at: (entry.published || entry.updated).content,
        title: entry.title.content,
        content: entry.content.content,
        link: entry.link.href,
      }
    end
  end

  def parse_rss(rss)
    rss.channel.items.map do |item|
      {
        published_at: item.pubDate,
        title: item.title,
        content: item.content_encoded || item.description,
        link: item.link,
      }
    end
  end

  def update_error(err)
    self.articles_json = nil
    self.error_text = err
    logger.warn(err)
  end

  def redirected(url)
    self.url = url
  end
end
