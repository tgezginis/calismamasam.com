class UsersController < Devise::RegistrationsController
  before_action :set_user, only: [:finish_signup, :update]

  def finish_signup
    if request.patch? && @user.present? && params[:user] && params[:user][:email]
      if @user.update(sign_up_params)
        sign_up_params[:subscriber_agreement] == '1' ? @user.add_as_subscriber : @user.opt_out_from_subscription
        bypass_sign_in(@user)
        redirect_to session[:previous_url] || root_path
      else
        @show_errors = true
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :subscriber_agreement)
  end

  def set_user
    @user = current_user || User.find(params[:id])
    redirect_to session[:previous_url] || root_path unless @user.present?
  end

  def after_sign_up_path_for(resource)
    current_user.add_as_subscriber
    super
  end
end
