require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  test "fetches new data" do
    res_body = <<END
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Feed Title</title>
  <id>Feed ID</id>
  <updated>1970-01-01T00:00:00Z</updated>
  <author>
    <name>Feed Author</name>
    <uri>http://feedauthor.test/</uri>
  </author>
</feed>
END
    stub_request(:get, 'http://agr.test/rss').to_return(body: res_body)
    feed = Feed.new(url: 'http://agr.test/rss')
    feed.refresh
    assert_equal('Feed Title', feed.name)
    assert_equal(res_body, feed.scrape)
    assert(feed.changed?)
  end
end
