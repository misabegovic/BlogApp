# frozen_string_literal: true

module Comments
  class ReactionsController < ApplicationController
    def create
      result = Reactions::CreateService.new(params[:comment_id], current_user.id, reaction_params).call

      respond_to do |format|
        format.js do
          render :create, locals: {
            result: result,
            current_user: current_user
          }
        end
      end
    end

    def destroy
      result = Reactions::DeleteService.new(params[:id], current_user.id).call

      respond_to do |format|
        format.js do
          render :destroy, locals: {
            result: result,
            comment: comment,
            current_user: current_user
          }
        end
      end
    end

    private

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
