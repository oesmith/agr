require "test_helper"

class NewsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  # test "should get index" do
  #   get news_index_url
  #   assert_response :success
  # end

  # test "should get refresh" do
  #   get news_refresh_url
  #   assert_response :success
  # end

  # test "should get show" do
  #   get news_show_url
  #   assert_response :success
  # end

end
