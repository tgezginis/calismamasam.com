require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
  end

  context 'associations' do
    it { should have_many(:products) }
  end

  it 'should have a name' do
    product_category = create(:product_category)
    expect(product_category.title).not_to be_nil
  end

  it 'should have a unique title' do
    product_category_1 = create(:product_category, title: 'Unique')
    product_category_2 = build(:product_category, title: 'Unique')
    expect { product_category_2.save }.not_to change { ProductCategory.count }
  end

  it 'should create with root parent' do
    parent_category = create(:product_category, parent: create(:product_category, title: 'Root'))
    root_category = parent_category.parent
    expect(root_category.root?).to be_truthy
  end
end
