FactoryBot.define do
  factory :product_brand do
    sequence(:name) { |n| "#{Faker::Name.name}#{n}" }
  end
end
