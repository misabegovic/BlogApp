# frozen_string_literal: true

class Reaction < ApplicationRecord
  belongs_to :comment
  belongs_to :user

  enum reaction_type: EnumValues::ReactionTypes::VALID_REACTION_TYPES
end
