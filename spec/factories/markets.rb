FactoryBot.define do
  factory :market do
    name { Faker::Hipster.word.capitalize + " " + Faker::Hipster.word.capitalize + " Market" }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { Faker::Address.community }
    state { Faker::Address.state }
    zip { Faker::Address.zip_code }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end