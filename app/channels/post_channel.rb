# frozen_string_literal: true

class PostChannel < ApplicationCable::Channel
  def subscribed
    stream_from "post_#{params[:post_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
