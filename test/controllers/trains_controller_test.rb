require "test_helper"
require "minitest/mock"

class TrainsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @train = trains(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trains)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create train" do
    assert_difference("Train.count") do
      post :create, params: { train: { from: @train.from, to: @train.to } }
    end
    assert_equal @user, assigns(:train).user
    assert_redirected_to train_path(assigns(:train))
  end

  test "should show train" do
    get :show, params: { id: @train }
    assert_redirected_to "/train/#{@train.from}/#{@train.to}"
  end

  test "should view departures for a given route" do
    # Stub out live departures calls, they're unit-tested elsewhere.
    Trains::LDB.stub(:live_departures, []) do
      Trains::TransportAPI.stub(:live_departures, []) do
        get :view, params: { from: "CPM", to: "PAD" }
        assert_response :success
      end
    end
  end

  test "should get edit" do
    get :edit, params: { id: @train }
    assert_response :success
  end

  test "should update train" do
    patch :update, params: { id: @train, train: { from: @train.from, to: @train.to } }
    assert_redirected_to train_path(assigns(:train))
  end

  test "should destroy train" do
    assert_difference("Train.count", -1) do
      delete :destroy, params: { id: @train }
    end
    assert_redirected_to trains_path
  end

  test "should not show other user's train" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, params: { id: trains(:three) }
    end
  end

  test "should not edit other user's train" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get :edit, params: { id: trains(:three) }
    end
  end

  test "should not update other user's train" do
    assert_raises(ActiveRecord::RecordNotFound) do
      patch :update, params: { id: trains(:three), train: { from: @train.from, to: @train.to } }
    end
  end

  test "should not destroy other user's train" do
    t = trains(:three)
    assert_difference("Train.count", 0) do
      assert_raises(ActiveRecord::RecordNotFound) do
        delete :destroy, params: { id: t }
      end
    end
  end
end
