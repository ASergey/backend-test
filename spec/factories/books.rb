FactoryBot.define do
  factory :book do
    title { FFaker::Book.title }
    publisher
  end
end
