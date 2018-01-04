FactoryBot.define do
  factory :product_category do
    sequence(:title) { |n| "#{Faker::Name.name}#{n}" }
  end
end