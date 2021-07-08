# frozen_string_literal: true

class CommentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "post_#{params[:post_id]}:comments"
    stream_from "post_#{params[:post_id]}:comments:user_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def generate_comment(data)
    ActionCable.server.broadcast(
      "post_#{params[:post_id]}:comments:user_#{current_user.id}",
      html: render_comment(data),
      data: data,
      type: :comment,
      action: :comment_render
    )
  end

  def generate_reaction(data)
    ActionCable.server.broadcast(
      "post_#{params[:post_id]}:comments:user_#{current_user.id}",
      html: render_reaction(data),
      data: data,
      type: :reaction,
      action: :reaction_render
    )
  end

  private

  def render_comment(data)
    ApplicationController.renderer.render(
      partial: 'posts/comments/comment_row',
      layout: false,
      locals: { comment: Comment.find(data['comment_id']),
                user: current_user }
    )
  end

  def render_reaction(data)
    ApplicationController.renderer.render(
      partial: 'comments/reactions/reaction_list_item',
      layout: false,
      locals: {
        comment: Comment.find(data['comment_id']),
        user: current_user,
        type: data['reaction_type']
      }
    )
  end
end
