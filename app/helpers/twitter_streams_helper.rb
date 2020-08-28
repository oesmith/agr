module TwitterStreamsHelper
  def tweet_author_link(tweet)
    link_to(
      "@#{tweet.user.screen_name}",
      "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}",
      class: "tweet-author-link",
      target: "_blank",
    )
  end

  def replace_entities(tweet)
    if (tweet.urls? || tweet.media?)
      urls = (tweet.urls + tweet.media).sort_by { |u| u.indices.first }
      t = ActiveSupport::SafeBuffer.new
      i = 0
      urls.each do |url|
        t << entities.decode(tweet.attrs[:full_text][i...url.indices.first])
        t << link_to(url.display_url, read_path(url: url.expanded_url.to_s))
        i = url.indices.second
      end
      t << entities.decode(tweet.attrs[:full_text][i..-1])
      return t
    end
    entities.decode(tweet.attrs[:full_text])
  end

  private

  def entities
    @htmlentities ||= HTMLEntities.new
  end
end
