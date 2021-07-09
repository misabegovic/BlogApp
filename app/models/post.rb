# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates_presence_of :title, :description

  after_commit :broadcast_update, on: :update
  after_commit :broadcast_destroy, on: :destroy

  private

  def trigger_post_broadcast(data)
    ActionCable.server.broadcast("post_#{id}", data)
  end

  def trigger_comments_broadcast(data)
    ActionCable.server.broadcast("post_#{id}:comments", data)
  end

  def broadcast_update
    data = {
      action: :update,
      type: :post,
      title: title,
      description: description
    }
    trigger_post_broadcast(data)
    trigger_comments_broadcast(data) if saved_change_to_title?
  end

  def broadcast_destroy
    data = {
      action: :destroy,
      type: :post
    }
    trigger_post_broadcast(data)
    trigger_comments_broadcast(data)
  end
end
