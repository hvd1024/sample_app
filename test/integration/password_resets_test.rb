require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template "password_resets/new"
    # Invalid email
    post password_resets_path, params: {password_reset: {email: ""}}
    assert_not flash.empty?
    assert_template "password_resets/new"
    # Valid email
    post password_resets_path,
      params: {password_reset: {email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
      params: {password_reset: {email: @user.email}}

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
      params: {email: @user.email,
               user: {password:              "foobar",
                      password_confirmation: "foobar"}}
    assert_response :redirect
    follow_redirect!
  end
end
