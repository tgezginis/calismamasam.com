FactoryBot.define do
  factory :gallery do
    user do
      FactoryBot.create(:user)
    end
    title Faker::Name.unique.name
    job_title Faker::Name.unique.name
    is_active true
  end
end
