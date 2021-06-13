# frozen_string_literal: true

module EnumValues
  class ReactionTypes
    LIKE = :like
    THUMBS_UP = :thumbs_up
    SMILE = :smile

    VALID_REACTION_TYPES = [
      LIKE,
      THUMBS_UP,
      SMILE
    ].freeze
  end
end
