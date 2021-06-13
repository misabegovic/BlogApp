# frozen_string_literal: true

module ReactionHelper
  def user_reacted?(comment, type)
    comment.user_reacted_by_type?(current_user, type)
  end

  def user_reaction(comment, type)
    comment.user_reaction_by_type(current_user, type)
  end
end
