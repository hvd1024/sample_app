class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.flash_send_rs"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_resets.flash_notfo"
      render :new
    end
  end

  def edit; end

  def update
    if @user.check_pw_empty params[:user][:password]
      @user.errors.add(:password, t("password_resets.not_empty"))
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t "password_resets.flash_rs_com"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def load_user
    @user = User.find_by(email: params[:email])
    return unless @user.blank?
    flash[:danger] = t "users.fl_notfound"
    redirect_to root_url
  end

  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    check_noti if @user.password_reset_expired?
  end

  def check_noti
    flash[:danger] = t "password_resets.flash_expired"
    redirect_to new_password_reset_url
  end
end
