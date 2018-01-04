class GalleriesController < ApplicationController
  before_action :find_gallery, only: %i[show like unlike]
  before_action :find_user, only: %i[like unlike]
  before_action :check_authentication, only: %i[new create]

  def index; end

  def show; end

  def like
    @like = @user.like(Gallery, @gallery.id)
    @likes_count = @gallery.likes_count
    @gallery.touch

    respond_to do |format|
      format.html { redirect_to(gallery_path(@gallery)) }
      format.js  { render 'shared/like' }
    end
  end

  def unlike
    @unlike = @user.unlike(Gallery, @gallery.id)
    @likes_count = @gallery.likes_count
    @gallery.touch

    respond_to do |format|
      format.html { redirect_to(gallery_path(@gallery)) }
      format.js  { render 'shared/unlike' }
    end
  end

  def new
    @gallery = Gallery.new
  end

  def create
    @gallery = Gallery.new(gallery_params)

    if @gallery.save
      render 'success'
    else
      render 'new'
    end
  end

  private

  def check_authentication
    return redirect_to new_user_session_path unless user_signed_in?
  end

  def find_gallery
    (@gallery = Gallery.fetch_by_slug(params[:id])) || raise('not found')
    redirect_to root_path unless @gallery.present?
  end

  def find_user
    (@user = User.fetch_by_token(params[:token])) || raise('not found')
    redirect_to new_user_session_path unless @user.present?
  end

  def gallery_params
    params.require(:gallery).permit(:title, :job_title, :user_id, :image, gallery_images_attributes: %i[title image _destroy])
  end
end
