require 'test_helper'

class AdminIntegrationTest < ActionDispatch::IntegrationTest

  setup do
    @user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin)
  end

  def login user
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password 
  end

  test "should not get /admin as anon" do
    get '/admin'
    assert_response :redirect
    assert_redirected_to root_path
    assert_equal I18n.t('podemos.unauthorized'), flash[:error] 
  end

  test "should not get /admin/resque as anon" do
    assert_raises(ActionController::RoutingError) do
      get '/admin/resque'
    end
  end

  test "should not get /admin as normal user" do
    login @user
    get '/admin'
    assert_response :redirect
    assert_redirected_to authenticated_root_path
    assert_equal I18n.t('podemos.unauthorized'), flash[:error] 
  end

  test "should not get /admin/resque as normal user" do
    login @user
    assert_raises(ActionController::RoutingError) do
      get '/admin/resque'
    end
  end

  test "should get /admin as admin user" do
    login @admin
    get '/admin'
    assert_response :success
  end

  test "should get /admin/resque as admin user" do
    login @admin
    get '/admin/resque'
    assert_response :redirect
    assert_redirected_to '/admin/resque/overview'
  end

end