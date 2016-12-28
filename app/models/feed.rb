require 'rss'

class Feed < ActiveRecord::Base
  def refresh
    res = Net::HTTP.get_response(URI(self.url))
    if res.code == '200'
      self.scrape = res.body
      rss = RSS::Parser.parse(res.body)
      self.name = rss.title.content
    end
  end
end
