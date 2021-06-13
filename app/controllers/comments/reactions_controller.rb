# frozen_string_literal: true

module Comments
  class ReactionsController < ApplicationController
    def create
      @reaction = Reaction.new(reaction_params)
      @reaction.user = current_user
      @reaction.comment = comment
      @reaction.save

      respond_to do |format|
        @reaction.save
        format.html { redirect_to post_comments_path(comment.post) }
      end
    end

    def update
      respond_to do |format|
        reaction.update(reaction_params)
        format.html { redirect_to post_comments_path(comment.post) }
      end
    end

    def destroy
      reaction.destroy
      redirect_to post_comments_path(comment.post)
    end

    private

    def reaction
      @reaction ||= comment.reactions.find(params[:id])
    end

    def comment
      @comment ||= Comment.find(params[:comment_id])
    end

    def reaction_params
      params.require(:reaction).permit(
        :reaction_type
      )
    end
  end
end
