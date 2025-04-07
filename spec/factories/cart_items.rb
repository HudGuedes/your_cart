FactoryBot.define do
  factory :cart_item do
    cart
    product
    quantity { rand(1..5) }
  end

  trait :quantity_zero do
    quantity { 0 }
  end

  trait :quantity_negative do
    quantity { -1 }
  end
end