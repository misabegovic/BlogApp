# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates_presence_of :title, :description

  after_commit :broadcast_update, on: :update
  after_commit :broadcast_destroy, on: :destroy

  private

  def trigger_broadcast(data)
    ActionCable.server.broadcast("post_#{id}", data)
  end

  def broadcast_update
    data = {
      action: :update,
      type: :post,
      title: title,
      description: description
    }
    trigger_broadcast(data)
  end

  def broadcast_destroy
    data = {
      action: :destroy,
      type: :post
    }
    trigger_broadcast(data)
  end
end
