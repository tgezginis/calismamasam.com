class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    respond_to do |format|
      update_method = user_params[:password].present? ? 'update_with_password' : 'update'
      if @user.send(update_method, user_params)
        user_params[:subscriber_agreement] == '1' ? @user.add_as_subscriber : @user.opt_out_from_subscription
        bypass_sign_in(@user)
        flash[:success] = 'Profiliniz güncellendi'
        format.html { render action: 'edit' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def voted
    @user = current_user
    @votedProducts = @user.likes.where(likeable_type: 'Product')
    render 'voted'
  end

  private

  def user_params
    accessible = %i[name email subscriber_agreement]
    accessible << %i[password password_confirmation current_password] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

  def set_user
    @user = current_user
    redirect_to session[:previous_url] || root_path unless @user.present?
  end
end
