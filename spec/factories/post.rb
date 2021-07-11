# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title                { Faker::Lorem.word }
    description          { Faker::Lorem.paragraph }
    user
    created_at           { Time.now }
    updated_at           { Time.now }
  end
end
