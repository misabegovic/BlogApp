# frozen_string_literal: true

module Comments
  class CreateService < BaseService
    def initialize(post_id, user_id, params)
      @post_id = post_id
      @user_id = user_id
      @params = params
    end

    def call
      execute(rescue_list: [ActiveRecord::RecordInvalid]) do
        comment = create_comment

        add_result(comment)
      end
    end

    private

    def create_comment
      comment = Comment.new(@params)
      comment.user_id = @user_id
      comment.post_id = @post_id
      save_and_raise!(ActiveRecord::RecordInvalid, comment.errors) unless comment.save

      comment
    end
  end
end
