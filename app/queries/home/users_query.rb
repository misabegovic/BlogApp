# frozen_string_literal: true

module Home
  class UsersQuery
    class << self
      delegate :call, to: :new
    end

    def initialize(current_user_id)
      @relation = User.none
      @current_user_id = current_user_id
    end

    def call(_params = {})
      filter_by_current_user

      @relation
    end

    private

    def filter_by_current_user
      @relation = User.where.not(id: @current_user_id) if @current_user_id
    end
  end
end
