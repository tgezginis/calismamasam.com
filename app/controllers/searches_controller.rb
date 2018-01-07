class SearchesController < ApplicationController
  def show
    @params = search_params
  end

  private

  def search_params
    params.permit(:query, :page, :category, :company, :product)
  end
end
