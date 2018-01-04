require 'rails_helper'

RSpec.describe ProductBrand, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  context 'associations' do
    it { should have_many(:products) }
  end

  it 'should have a name' do
    product_brand = create(:product_brand)
    expect(product_brand.name).not_to be_nil
  end

  it 'should have a unique name' do
    product_brand_1 = create(:product_brand, name: 'Unique')
    product_brand_2 = build(:product_brand, name: 'Unique')
    expect { product_brand_2.save }.not_to change { ProductBrand.count }
  end
end
