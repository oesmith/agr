require "test_helper"

class TwitterConfigTest < ActiveSupport::TestCase
  test "should initialize from omniauth hash" do
    obj = TwitterConfig.from_oauth({
      credentials: {
        token: "tok",
        secret: "sec",
      },
    })
    assert_equal("tok", obj.oauth_token)
    assert_equal("sec", obj.oauth_secret)
  end
end
