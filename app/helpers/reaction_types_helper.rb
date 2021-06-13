# frozen_string_literal: true

module ReactionTypesHelper
  include EnumValues

  def like_type
    ReactionTypes::LIKE.to_s
  end

  def thumbs_up_type
    ReactionTypes::THUMBS_UP.to_s
  end

  def smile_type
    ReactionTypes::SMILE.to_s
  end

  def reactions_count(comment, type)
    comment.reactions.where(reaction_type: type).count
  end

  def humanize_type(type)
    case type
    when like_type
      'Like'
    when thumbs_up_type
      'Thumbs Up'
    when smile_type
      'Smile'
    end
  end
end
