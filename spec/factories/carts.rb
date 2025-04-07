FactoryBot.define do
  factory :cart do
    total_price { 10.0 }
    cart_abandoned { false }
    last_interaction_at { Time.current }

    trait :abandoned do
      cart_abandoned { true }
    end

    trait :cart_with_4h_interaction do
      last_interaction_at { 4.hours.ago }
    end
  end
end