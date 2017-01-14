require 'rss'

class Feed < ActiveRecord::Base
  belongs_to :user

  ALTERNATE_TYPES = ['application/atom+xml', 'application/rss+xml']

  def self.resolve(url, redirects=10)
    raise ArgumentError, 'Too many redirects' if redirects == 0
    url = URI("http://#{url.to_s}") if url.scheme.nil?
    res = Net::HTTP.get_response(url)
    case res
    when Net::HTTPSuccess then
      if res.content_type == 'text/html'
        # Attempt to find a link[rel=alternate] in the page.
        html = Nokogiri::HTML(res.body)
        alternate = html.css('link[rel="alternate"]').find do |e|
          e.attributes['type'] and ALTERNATE_TYPES.include? e.attributes['type'].value
        end
        raise "Unable to find a feed at #{url.to_s}" if alternate.nil?
        resolve(URI.join(url, alternate.attributes['href'].value), redirects - 1)
      else
        rss = RSS::Parser.parse(res.body)
        case "#{rss.feed_type}/#{rss.feed_version}"
        when "atom/1.0"
          Feed.new(url: url.to_s, name: rss.title.content)
        when "rss/2.0"
          Feed.new(url: url.to_s, name: rss.channel.title)
        else
          raise "Unsupported feed type #{rss.feed_type}/#{rss.feed_version}"
        end
      end
    when Net::HTTPRedirection then
      # Follow redirects.
      resolve(URI.join(url, res['location']), redirects - 1)
    else
      raise "HTTP fetch error (#{res.code})"
    end
  end
end
