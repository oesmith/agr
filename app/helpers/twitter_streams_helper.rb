module TwitterStreamsHelper
  def replace_entities(tweet)
    if tweet.urls?
      t = ActiveSupport::SafeBuffer.new
      i = 0
      tweet.urls.each do |url|
        t << entities.decode(tweet.attrs[:full_text][i...url.indices.first])
        t << link_to(url.display_url, url.expanded_url.to_s)
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