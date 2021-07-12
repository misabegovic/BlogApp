# frozen_string_literal: true

FactoryBot.define do
  factory :reaction do
    reaction_type { 0 }
    user
    comment
    created_at           { Time.now }
    updated_at           { Time.now }
  end
end
