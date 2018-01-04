require 'rails_helper'

RSpec.describe Gallery, type: :model do
  let(:gallery) { create(:gallery) }

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:job_title) }
    it { should validate_presence_of(:user_id) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:gallery_images) }
    it { should have_and_belong_to_many(:categories) }
    it { should have_many(:likes) }
  end

  it 'has a valid slug' do
    expect(gallery.slug).not_to be_nil
  end

  it 'has a gallery image' do
    create(:gallery_image, gallery: gallery)
    expect(gallery.gallery_images.any?).to be_truthy
  end
end
