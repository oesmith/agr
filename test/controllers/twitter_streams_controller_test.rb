require "test_helper"

class TwitterStreamsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    sign_in(users(:one))
  end

  test "should show twitter stream" do
    get :show, params: { id: streams(:twitter_one) }
    assert_response :success
  end

  test "should not show other user's twitter stream" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, params: { id: streams(:twitter_two) }
    end
  end
end
