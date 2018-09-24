class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def logged_in_user
    check_log_ac unless logged_in?
  end

  def check_log_ac
    store_location
    flash[:danger] = "Please log in."
    redirect_to login_url
  end
end
