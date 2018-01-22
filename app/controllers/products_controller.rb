class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:vote]
  before_action :find_product, only: [:show, :vote]

  def show
    @posts = @product.posts.active

    cache_key = ['product-stats-data-result', @product&.id, Post.active.maximum(:updated_at), Product.maximum(:updated_at)]
    result = Rails.cache.fetch(cache_key) do
      StatsInteractors::GetProductChartData.call(product: @product)
    end

    @chart_data = result.chart_data if result.success?
  end

  def vote
    if !@product.liked? current_user
      current_user.like(Product, @product.id)
    elsif @product.liked? current_user
      current_user.unlike(Product, @product.id)
    end

    respond_to do |format|
      isVoted = @product.liked? current_user
      format.json { render json: { :status => isVoted } }
    end
  end

  private

  def find_product
    @product = Product.fetch_by_slug(params[:id])
    return redirect_to root_path unless @product.present?
    @product = @product.decorate
  end
end
