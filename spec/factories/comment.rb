# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    description { Faker::Lorem.paragraph }
    user
    post
    created_at           { Time.now }
    updated_at           { Time.now }
  end
end
