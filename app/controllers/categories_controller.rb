class CategoriesController < ApplicationController
  before_action :find_category, only: %i[show]

  def index; end

  def show; end

  private

  def find_category
    (@category = Category.fetch_by_slug(params[:id])) || raise('not found')
    redirect_to root_path unless @category.present?
  end
end
