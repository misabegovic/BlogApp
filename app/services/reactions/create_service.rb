# frozen_string_literal: true

module Reactions
  class CreateService < BaseService
    def initialize(comment_id, user_id, params)
      @comment_id = comment_id
      @user_id = user_id
      @params = params
    end

    def call
      execute(rescue_list: [ActiveRecord::RecordInvalid]) do
        reaction = create_reaction

        add_result(reaction)
      end
    end

    private

    def create_reaction
      reaction = Reaction.new(@params)
      reaction.user_id = @user_id
      reaction.comment_id = @comment_id
      save_and_raise!(ActiveRecord::RecordInvalid, reaction.errors) unless reaction.save

      reaction
    end
  end
end
