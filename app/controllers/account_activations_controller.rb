class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      update_active user
    else
      flash[:danger] = t "controllers.flash_inval"
      redirect_to root_url
    end
  end

  def update_active user
    user.activate
    user.update_attribute(:activated, true)
    user.update_attribute(:activated_at, Time.zone.now)
    log_in user
    flash[:success] = t "controllers.flash_activ"
    redirect_to user
  end
end
