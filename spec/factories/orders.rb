FactoryBot.define do
  factory :order do
    book { nil }
    customer_email { "MyString" }
    customer_name { "MyString" }
    total_amount { "9.99" }
    stripe_payment_intent_id { "MyString" }
    status { "MyString" }
    purchased_at { "2025-09-08 16:09:12" }
  end
end
