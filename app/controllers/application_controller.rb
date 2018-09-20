class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def logged_in_user
    check_log_ac unless logged_in?
  end

  def check_log_ac
    store_location
    flash[:danger] = t "controllers.flash_pls_login"
    redirect_to login_url
  end
end
