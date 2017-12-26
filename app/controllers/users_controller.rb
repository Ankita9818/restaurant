class UsersController < ApplicationController
  before_action :authorize, only: [:edit, :update]
  before_action :validate_user, only: [:show, :edit, :update]
  before_action :load_user, only: [:confirm_email]

  def new
    @user = User.new
  end

  def create
    @user = User.new(permitted_params)
    if @user.save
      flash_message("success", "confirm_email", login_url)
    else
      render 'new'
    end
  end

  def confirm_email
    @user.activate_email
    flash_message("success", "email_confirmed", login_url)
  end

  def update
    if @user.update(permitted_params)
      flash_message("success", "successfully_saved", login_url)
    else
      render 'edit'
    end
  end

  private
    def permitted_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end

    def validate_user
      @user = User.find(session[:user_id])
      flash_message("danger", "other_account", login_url) unless @user == current_user
    end

    def load_user
      @user = User.find_by(id: params[:id])
      flash_message("danger", 'user_not_exist', new_user_url) unless @user
    end
end
