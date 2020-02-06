require "test_helper"

class FeedTest < ActiveSupport::TestCase
  ATOM_DOC = <<END
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Atom Feed Title</title>
  <id>Feed ID</id>
  <updated>1970-01-01T00:00:00Z</updated>
  <author>
    <name>Feed Author</name>
    <uri>http://feedauthor.test/</uri>
  </author>
</feed>
END

  RSS_DOC = <<END
<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>RSS Feed Title</title>
    <link>http://agr.test/</link>
    <description>Test feed</description>
  </channel>
</rss>
END

  ALTERNATE_DOC = <<END
<?doctype html>
<head>
  <link rel="alternate" type="application/rss+xml" href="http://agr.test/rss">
</head>
END

  setup do
    stub_request(:get, "http://agr.test/atom").to_return(body: ATOM_DOC)
    stub_request(:get, "http://agr.test/rss").to_return(body: RSS_DOC)
    stub_request(:get, "http://agr.test/alternate").to_return(body: ALTERNATE_DOC, headers: { "Content-Type" => "text/html" })
    stub_request(:get, "http://agr.test/redirect").to_return(status: 302, headers: { Location: "http://agr.test/rss" })
  end

  test "resolves atom 1.0 feeds" do
    feed = Feed.resolve(URI("http://agr.test/atom"))
    assert_equal("http://agr.test/atom", feed.url)
    assert_equal("Atom Feed Title", feed.name)
  end

  test "resolves rss feeds" do
    feed = Feed.resolve(URI("http://agr.test/rss"))
    assert_equal("http://agr.test/rss", feed.url)
    assert_equal("RSS Feed Title", feed.name)
  end

  test "follows redirects" do
    feed = Feed.resolve(URI("http://agr.test/redirect"))
    assert_equal("http://agr.test/rss", feed.url)
    assert_equal("RSS Feed Title", feed.name)
  end

  test "follows alternate links" do
    feed = Feed.resolve(URI("http://agr.test/alternate"))
    assert_equal("http://agr.test/rss", feed.url)
    assert_equal("RSS Feed Title", feed.name)
  end
end
