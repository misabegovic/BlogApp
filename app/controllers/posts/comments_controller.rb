# frozen_string_literal: true

module Posts
  class CommentsController < ApplicationController
    def index
      @comments = post.comments.sort_by_updated_at.includes(:reactions)
    end

    def create
      @comment = Comment.new(comment_params)
      @comment.user = current_user
      @comment.post = post
      @comment.save

      respond_to do |format|
        @comment.save
        format.html { redirect_to post_comments_path(post) }
      end
    end

    def update
      respond_to do |format|
        comment.update(comment_params)
        format.html { redirect_to post_comments_path(post) }
      end
    end

    def destroy
      comment.destroy
      redirect_to post_comments_path(post)
    end

    private

    def comment
      @comment ||= post.comments.find(params[:id])
    end

    def post
      @post ||= Post.find(params[:post_id])
    end

    def comment_params
      params.require(:comment).permit(
        :description
      )
    end
  end
end
