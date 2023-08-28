FactoryBot.define do
  factory :vendor do
    name { Faker::Hipster.word.capitalize + " " + Faker::Hipster.word.capitalize + " Goods" }
    description { Faker::Hipster.sentence }
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end
