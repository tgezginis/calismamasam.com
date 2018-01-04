FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "#{Faker::Name.unique.name}#{n}" }
    category do
      FactoryBot.create(:product_category)
    end
    brand do
      FactoryBot.create(:product_brand)
    end
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'data', 'valid_image.png'), 'image/png') }
  end
end
