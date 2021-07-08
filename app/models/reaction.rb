# frozen_string_literal: true

class Reaction < ApplicationRecord
  belongs_to :comment
  belongs_to :user

  enum reaction_type: EnumValues::ReactionTypes::VALID_REACTION_TYPES

  after_commit :broadcast_create, on: :create
  after_commit :broadcast_destroy, on: :destroy

  private

  def trigger_broadcast(data)
    ActionCable.server.broadcast("post_#{comment.post_id}:comments", data)
  end

  def broadcast_create
    data = {
      action: :create,
      type: :reaction,
      reaction_id: id,
      reaction_type: reaction_type.to_s,
      reaction_count: comment.reactions.where(reaction_type: reaction_type).count,
      comment_id: comment_id,
      owner_id: user_id
    }
    trigger_broadcast(data)
  end

  def broadcast_destroy
    data = {
      action: :destroy,
      type: :reaction,
      reaction_id: id,
      reaction_type: reaction_type.to_s,
      reaction_count: comment.reactions.where(reaction_type: reaction_type).count,
      comment_id: comment_id,
      owner_id: user_id
    }
    trigger_broadcast(data)
  end
end
