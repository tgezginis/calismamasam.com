require 'rails_helper'

RSpec.describe GalleryDecorator, type: :decorator do
  let(:category) { create(:category) }
  let(:gallery) { create(:gallery) }

  # Product contexts
  subject(:context_gallery) do
    gallery
    gallery.categories << category
    described_class.new(gallery)
  end

  context 'first_image_url' do
    it 'should be string' do
      expect(context_gallery.first_image_url.class).to be(String)
    end

    it 'should be missing url' do
      first_image_url = "/gallery-images/full/missing.png"
      expect(context_gallery.first_image_url(:full)).to eq(first_image_url)
    end
  end

  context 'category_titles' do
    it 'should be string' do
      expect(context_gallery.category_titles.class).to be(String)
    end

    it 'should be context category' do
      expect(context_gallery.category_titles).to eq(category.title)
    end
  end
end
