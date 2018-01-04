require 'rails_helper'

RSpec.describe ProductDecorator, type: :decorator do
  let(:product) { create(:product) }

  # Product contexts
  subject(:context_product) do
    product
    described_class.new(product)
  end

  context 'name_with_brand' do
    it 'should be string' do
      expect(context_product.name_with_brand.class).to be(String)
    end

    it 'should concat name and brand name' do
      name_with_brand = "#{context_product.brand.name} #{context_product.name}"
      expect(context_product.name_with_brand).to eq(name_with_brand)
    end

    it 'should be only name when is the name and the title name same' do
      context_product.name = context_product.brand.name
      name_with_brand = context_product.brand.name
      expect(context_product.name_with_brand).to eq(name_with_brand)
    end
  end

  context 'image_url' do
    it 'should be string' do
      expect(context_product.image(:full).class).to be(String)
    end

    it 'should be missing url' do
      context_product.image = nil
      image_url = "/product-images/full/missing.png"
      expect(context_product.image(:full)).to eq(image_url)
    end
  end
end
