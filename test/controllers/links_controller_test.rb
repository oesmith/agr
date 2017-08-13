require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @link = links(:one)
  end

  test "should get index" do
    get links_url
    assert_response :success
  end

  test "should get new" do
    get new_link_url
    assert_response :success
  end

  test "should create link" do
    stub_request(:get, @link.url).to_return(status: 200, body: "<head><title>Foo bar</title></head>")

    assert_difference('Link.count') do
      post links_url, params: { link: { url: @link.url } }
    end
    assert_redirected_to links_url

    assert_equal "Foo bar", Link.last.title
    assert_nil Link.last.followed_at
  end

  test "should show link" do
    get link_url(@link)
    assert_redirected_to @link.url
    assert_not_nil @link.reload.followed_at
  end

  test "should destroy link" do
    assert_difference('Link.count', -1) do
      delete link_url(@link)
    end

    assert_redirected_to links_url
  end
end
