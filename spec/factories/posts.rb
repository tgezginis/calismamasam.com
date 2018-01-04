FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "#{Faker::Name.unique.name}#{n}" }
    is_active false
    job_title 'Software Developer'
    company Faker::Company.name
    twitter_url 'https://twitter.com/calismamasamcom'
    body Faker::Lorem.paragraphs(20)
    description Faker::Lorem.paragraph
    published_at Time.current
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'data', 'valid_image.png'), 'image/png') }
  end
end
