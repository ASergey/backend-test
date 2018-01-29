FactoryBot.define do
  factory :publisher do
    name { FFaker::BaconIpsum.word }
  end
end
