# frozen_string_literal: true

module Comments
  class UpdateService < BaseService
    def initialize(comment_id, user_id, params)
      @comment_id = comment_id
      @user_id = user_id
      @params = params
    end

    def call
      execute(rescue_list: [ActiveRecord::RecordInvalid]) do
        comment = find_comment
        validate_owner!(comment)
        update_comment(comment)

        add_result(comment)
      end
    end

    private

    def find_comment
      Comment.find(@comment_id)
    end

    def validate_owner!(comment)
      save_and_raise!(ActiveRecord::RecordInvalid, ownership_error) unless owner_of_comment?(comment)
    end

    def owner_of_comment?(comment)
      comment.user_id == @user_id
    end

    def ownership_error
      comment = Comment.new
      comment.errors.add(:Unauthorized, ', you are not the owner of this comment')
    end

    def update_comment(comment)
      save_and_raise!(ActiveRecord::RecordInvalid, comment.errors) unless comment.update(@params)

      comment
    end
  end
end
