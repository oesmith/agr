class TwitterStream < Stream
  serialize :config, TwitterConfig
  serialize :profile, TwitterProfile
  # serialize :stream, TwitterStream

  def type_name
    "Twitter"
  end

  def printable_name
    "@#{profile.screen_name}"
  end
end