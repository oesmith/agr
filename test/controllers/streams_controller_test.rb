require "test_helper"

class StreamsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    sign_in(users(:one))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:streams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should destroy stream" do
    assert_difference("Stream.count", -1) do
      delete :destroy, params: { id: streams(:twitter_one) }
    end
    assert_redirected_to streams_path
  end

  test "should not destroy other user's stream" do
    s = streams(:twitter_two)
    assert_difference("Stream.count", 0) do
      assert_raises(ActiveRecord::RecordNotFound) do
        delete :destroy, params: { id: s }
      end
    end
  end
end
