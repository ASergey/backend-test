FactoryBot.define do
  factory :books_in_shop do
    book
    shop
    sold_count 1
    in_stock 1
  end
end
