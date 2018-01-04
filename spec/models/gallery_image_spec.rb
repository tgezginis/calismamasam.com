require 'rails_helper'

RSpec.describe GalleryImage, type: :model do
  let(:gallery) { create(:gallery) }
  let(:gallery_image) { create(:gallery_image, gallery: gallery) }

  context 'validations' do
    it { should validate_presence_of(:title) }
  end

  context 'associations' do
    it { should belong_to(:gallery) }
  end

  it 'has an image' do
    gallery_image.image = nil
    expect(gallery_image.image).not_to be_nil
  end
end
