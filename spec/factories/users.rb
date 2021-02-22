FactoryBot.define do
  factory :user do
    email { "contributor@test.com" }
    password  { "password" }
    type { 'Contributor' }
  end
end