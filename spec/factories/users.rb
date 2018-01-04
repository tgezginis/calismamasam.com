FactoryBot.define do
  password = Faker::Internet.password(8)
  factory :user do
    sequence(:name) { |n| "#{Faker::Name.unique.name}#{n}" }
    sequence(:email) { |n| "#{n}#{Faker::Internet.email}" }
    password password
    password_confirmation password
    role :admin
  end
end
