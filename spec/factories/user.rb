# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email                { Faker::Internet.email }
    password             { Faker::Internet.password }
    created_at           { Time.now }
    updated_at           { Time.now }
  end
end
