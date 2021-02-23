FactoryBot.define do
  factory :user do
    email { "contributor@test.com" }
    password  { "password" }
    type { 'Contributor' }
  end

  factory :company do
    name { "company1" }
    user_id {}
  end
  factory :brand do
    name { "brand1" }
    user_id {}
  end
end