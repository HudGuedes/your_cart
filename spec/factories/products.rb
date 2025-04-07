FactoryBot.define do
  factory :product do
    name { "Produto #{Faker::Commerce.product_name}" }
    price { Faker::Commerce.price(range: 5.0..100.0) }
  end
end