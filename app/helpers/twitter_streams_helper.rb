module TwitterStreamsHelper
  def replace_entities(tweet)
    if (tweet.urls? || tweet.media?)
      urls = (tweet.urls + tweet.media).sort_by { |u| u.indices.first }
      t = ActiveSupport::SafeBuffer.new
      i = 0
      urls.each do |url|
        t << entities.decode(tweet.attrs[:full_text][i...url.indices.first])
        t << link_to(url.display_url, url.expanded_url.to_s, target: '_blank')
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
