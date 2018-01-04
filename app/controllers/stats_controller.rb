class StatsController < ApplicationController
  def index
    @product_categories = ProductCategory.roots.order(title: :asc)
    @post_category = Category.friendly.find(params[:post_category_id]) unless params[:post_category_id].nil?

    if params[:id]
      @parent_product_category = ProductCategory.find_by(slug: params[:id])
      return redirect_to stats_path unless @parent_product_category

      cache_key = ['stats-data-result', params[:id], @post_category&.id, Post.active.maximum(:updated_at), Product.maximum(:updated_at)]
      result = Rails.cache.fetch(cache_key) do
        StatsInteractors::GetChartData.call(parent_product_category: @parent_product_category, post_category: @post_category)
      end

      if result.success?
        @chart_data = result.chart_data
        return redirect_to stats_path(id: @parent_product_category.slug) unless @chart_data.any?

        @product_ids = result.product_ids
        @child_categories = @parent_product_category.children.order(title: :asc)

        @all_posts = Post.active.includes(:products).where('products.id' => result.products.pluck(:id)).order(id: :desc)
        if @post_category.present?
          @posts = @post_category.posts.active.includes(:products).where('products.id' => result.products.pluck(:id)).order(id: :desc)
        else
          @posts = @all_posts
        end

        cache_key = ['stats-categories', params[:id], @post_category&.id, @all_posts.maximum(:updated_at)]
        @categories = Rails.cache.fetch(cache_key) do
          Category.where(id: @all_posts.map { |p| p.categories.pluck(:id) }.flatten.uniq).order(title: :asc)
        end
      end
    end
  end
end
