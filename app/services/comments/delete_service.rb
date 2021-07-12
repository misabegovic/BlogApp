# frozen_string_literal: true

module Comments
  class DeleteService < BaseService
    def initialize(comment_id, user_id)
      @comment_id = comment_id
      @user_id = user_id
    end

    def call
      execute(rescue_list: [ActiveRecord::RecordInvalid]) do
        comment = find_comment
        validate_owner!(comment)
        delete_comment!(comment)

        add_result(true)
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
      comment.errors
    end

    def delete_comment!(comment)
      save_and_raise!(ActiveRecord::RecordInvalid, comment.errors) unless comment.destroy
    end
  end
end
