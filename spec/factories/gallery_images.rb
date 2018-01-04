FactoryBot.define do
  factory :gallery_image do
    gallery do
      FactoryBot.create(:gallery)
    end
    title Faker::Name.unique.name
    position 1
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'data', 'valid_image.png'), 'image/png') }
  end
end
