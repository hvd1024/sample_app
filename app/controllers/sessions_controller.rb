class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    user_check user
  end

  def user_check user
    if user&.authenticate(params[:session][:password])
      user_active user
    else
      flash.now[:danger] = t(".flash_invalid")
      render :new
    end
  end

  def user_active user
    if user.activated?
      user_login user
    else
      flash[:warning] = t "sessions.warn"
      redirect_to root_url
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def user_login user
    log_in user
    if params[:session][:remember_me] == Settings.ss_controllers.remember_check
      remember(user)
    else
      forget(user)
    end
    redirect_back_or user
  end

  def check_remem
    params[:session][:remember_me] == Settings.ss_controllers.remember_check
  end
end
