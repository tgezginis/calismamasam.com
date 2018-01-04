require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { create(:category) }

  context 'validations' do
    it { should validate_presence_of(:title) }
  end

  context 'associations' do
    it { should have_and_belong_to_many(:posts) }
  end

  it 'is invalid without title' do
    category.title = nil
    expect(category).not_to be_valid
  end

  it 'has a valid slug' do
    expect(category.slug).not_to be_nil
  end
end
