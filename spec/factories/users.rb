FactoryBot.define do
  factory :user do
    email { "contributor@test.com" }
    password  { "password" }
    type { 'Contributor' }
    created_by_id { }
  end

  factory :company do
    name { "company1" }
    user_id {}
  end
  factory :brand do
    name { "brand1" }
    user_id {}
    company_id {}
  end
  factory :brand_manager do
	user_id {}
	admin_id {}
	brand_id {}
  end
end