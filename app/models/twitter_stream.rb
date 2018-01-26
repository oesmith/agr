class TwitterStream < Stream
  serialize :config, TwitterConfig
  serialize :profile, TwitterProfile
  serialize :stream, TwitterPosts

  def type_name
    "Twitter"
  end

  def printable_name
    "@#{profile.screen_name}"
  end
  
  def refresh
    stream.timeline = client.home_timeline(count: 100)
    stream.mentions = client.mentions_timeline(count: 5)
    self
  end
  
  def client
    @client ||= Twitter::REST::Client.new do |c|
      c.consumer_key = ENV["TWITTER_KEY"]
      c.consumer_secret = ENV["TWITTER_SECRET"]
      c.access_token = config.oauth_token
      c.access_token_secret = config.oauth_secret
    end
  end
end