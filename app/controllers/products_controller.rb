class ProductsController < ApplicationController
  before_action :find_product, only: %i[show]
  def show
    @posts = @product.posts.active

    cache_key = ['product-stats-data-result', @product&.id, Post.active.maximum(:updated_at), Product.maximum(:updated_at)]
    result = Rails.cache.fetch(cache_key) do
      StatsInteractors::GetProductChartData.call(product: @product)
    end

    @chart_data = result.chart_data if result.success?
  end

  private

  def find_product
    @product = Product.fetch_by_slug(params[:id])
    return redirect_to root_path unless @product.present?
    @product = @product.decorate
  end
end
