FactoryBot.define do
  factory :book do
    title { "MyString" }
    author { "MyString" }
    price { "9.99" }
    description { "MyText" }
    cover_image { "MyString" }
    isbn { "MyString" }
    stock { 1 }
  end
end
