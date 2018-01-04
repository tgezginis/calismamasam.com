# coding: utf-8
class Api::V1::PostsController < ApplicationController
  def index
    @posts = Post.active
    render json: @posts
  end

  def show
    @post = Post.friendly.find(params[:id])
    render json: @post, serializer: PostSerializer
  end
end