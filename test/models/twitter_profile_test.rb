require 'test_helper'

class TwitterProfileTest < ActiveSupport::TestCase
  test "should initialize from omniauth hash" do
    obj = TwitterProfile.from_oauth({
      info: {
        nickname: "philz",
        name: "Phil McPhil",
        image: "http://example.com/philz.png",
      }
    })
    assert_equal("philz", obj.screen_name)
    assert_equal("Phil McPhil", obj.real_name)
    assert_equal("http://example.com/philz.png", obj.profile_image)
  end
end