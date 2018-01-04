require 'rails_helper'

RSpec.describe ProductCategoryDecorator, type: :decorator do
  let(:product_category) { create(:product_category) }

  # Product category contexts
  subject(:context_product_category) do
    product_category
    described_class.new(product_category)
  end
end
