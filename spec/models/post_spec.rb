require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:job_title) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:published_at) }
  end

  context 'associations' do
    it { should have_and_belong_to_many(:categories) }
    it { should have_and_belong_to_many(:products) }
    it { should have_many(:post_images) }
    it { should have_many(:likes) }
  end

  it 'has an image' do
    post.image = nil
    expect(post.image).not_to be_nil
  end

  it 'has a product' do
    post.products << create(:product)
    expect(post.products.any?).to be_truthy
  end

  it 'has a valid slug' do
    expect(post.slug).not_to be_nil
  end

  it 'has a post image' do
    create(:post_image, post: post)
    expect(post.post_images.any?).to be_truthy
  end

  it 'has a category' do
    post.categories << create(:category)
    expect(post.categories.any?).to be_truthy
  end
end
