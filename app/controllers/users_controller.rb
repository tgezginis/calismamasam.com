class UsersController < Devise::RegistrationsController
  before_action :set_user, only: [:finish_signup]

  def finish_signup
    if request.patch? && @user.present? && params[:user] && params[:user][:email]
      if @user.update(sign_up_params)
        bypass_sign_in(@user)
        redirect_to session[:previous_url] || root_path
      else
        @show_errors = true
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
