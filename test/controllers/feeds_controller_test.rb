require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper
  include Devise::Test::ControllerHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @feed = feeds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feeds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feed" do
    assert_difference('Feed.count') do
      post :create, params: { feed: { url: @feed.url } }
    end

    assert_redirected_to feed_path(assigns(:feed))
  end

  test "should show feed" do
    get :show, params: { id: @feed }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @feed }
    assert_response :success
  end

  test "should update feed" do
    patch :update, params: { id: @feed, feed: { url: @feed.url } }
    assert_redirected_to feed_path(assigns(:feed))
  end

  test "should destroy feed" do
    assert_difference('Feed.count', -1) do
      delete :destroy, params: { id: @feed }
    end

    assert_redirected_to feeds_path
  end

  test "should refresh feed" do
    assert_enqueued_with(job: RefreshFeedJob, args: [@feed]) do
      post :refresh, params: { id: @feed }
    end
    assert_redirected_to feed_path(assigns(:feed))
  end
end
