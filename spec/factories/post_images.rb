FactoryBot.define do
  factory :post_image do
    post do
      FactoryBot.create(:post)
    end
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'data', 'valid_image.png'), 'image/png') }
  end
end
