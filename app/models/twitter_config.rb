class TwitterConfig
  include ActiveModel::Model
  attr_accessor :oauth_token, :oauth_secret

  def self.from_oauth(h)
    # Initalise a config object from the hash provided by omniauth-twitter.
    TwitterConfig.new({
      oauth_token: h[:credentials][:token],
      oauth_secret: h[:credentials][:secret],
    })
  end
end