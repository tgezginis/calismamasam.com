require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create(:product) }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:category_id) }
    it { should validate_uniqueness_of(:name) }
  end

  context 'associations' do
    it { should belong_to(:brand) }
    it { should belong_to(:category) }
    it { should have_and_belong_to_many(:posts) }
  end

  it 'is invalid without name' do
    product.name = nil
    expect(product).not_to be_valid
  end

  it 'is invalid without category' do
    product.category_id = nil
    expect(product).not_to be_valid
  end

  it 'should have a unique name' do
    create(:product, name: 'Unique')
    product2 = build(:product, name: 'Unique')
    expect { product2.save }.not_to change { Product.count }
  end
end
