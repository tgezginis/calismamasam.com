class PostsController < ApplicationController
  before_action :find_post, only: %i[show like unlike]
  before_action :find_user, only: %i[like unlike]

  def show; end

  def like
    @like = @user.like(Post, @post.id)
    @likes_count = @post.likes_count
    @post.touch

    respond_to do |format|
      format.html { redirect_to(post_path(@post)) }
      format.js  { render 'shared/like' }
    end
  end

  def unlike
    @unlike = @user.unlike(Post, @post.id)
    @likes_count = @post.likes_count
    @post.touch

    respond_to do |format|
      format.html { redirect_to(post_path(@post)) }
      format.js  { render 'shared/unlike' }
    end
  end

  def about; end

  def feed
    @posts = Post.active
    respond_to do |format|
      format.rss { render layout: false }
    end
  end

  private

  def find_post
    @post = Post.fetch_by_slug(params[:id])
    return redirect_to root_path unless @post.present?
    @post = @post.decorate
    redirect_to root_path unless @post.active?
  end

  def find_user
    (@user = User.fetch_by_token(params[:token])) || raise('not found')
    redirect_to new_user_session_path unless @user.present?
  end
end
