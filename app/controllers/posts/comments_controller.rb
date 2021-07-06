# frozen_string_literal: true

module Posts
  class CommentsController < ApplicationController
    def index
      @comments = Posts::CommentsQuery.new(post.id, include_reactions: true).call
    end

    def create
      result = Comments::CreateService.new(params[:post_id], current_user.id, comment_params).call

      respond_to do |format|
        format.js do
          render :create, locals: {
            result: result,
            current_user: current_user
          }
        end
      end
    end

    def edit
      comment = current_user.comments.find(params[:id])

      respond_to do |format|
        format.js do
          render :edit, locals: {
            comment: comment
          }
        end
      end
    end

    def update
      result = Comments::UpdateService.new(params[:id], current_user.id, comment_params).call

      respond_to do |format|
        format.js do
          render :update, locals: {
            result: result,
            current_user: current_user
          }
        end
      end
    end

    def destroy
      result = Comments::DeleteService.new(params[:id], current_user.id).call

      respond_to do |format|
        format.js do
          render :destroy, locals: {
            result: result,
            post: post,
            comment_id: params[:id]
          }
        end
      end
    end

    private

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
