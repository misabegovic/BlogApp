# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many :reactions, dependent: :destroy

  validates_presence_of :description

  def user_reacted_by_type?(user, type)
    reactions.where(reaction_type: type).where(user_id: user.id).count.positive?
  end

  def user_reaction_by_type(user, type)
    reactions.where(reaction_type: type).find_by(user_id: user.id)
  end

  after_commit :broadcast_create, on: :create
  after_commit :broadcast_update, on: :update
  after_commit :broadcast_destroy, on: :destroy

  private

  def trigger_broadcast(data)
    ActionCable.server.broadcast("post_#{post_id}:comments", data)
  end

  def broadcast_create
    data = {
      action: :create,
      type: :comment,
      comment_id: id
    }
    trigger_broadcast(data)
  end

  def broadcast_update
    data = {
      action: :update,
      type: :comment,
      comment_id: id,
      description: description
    }
    trigger_broadcast(data)
  end

  def broadcast_destroy
    return if post.frozen?

    data = {
      action: :destroy,
      type: :comment,
      comment_id: id
    }
    trigger_broadcast(data)
  end
end
