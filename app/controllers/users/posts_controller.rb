# frozen_string_literal: true

module Users
  class PostsController < ApplicationController
    def index
      @posts = user.posts
    end

    private

    def user
      @user ||= User.find(params[:user_id])
    end
  end
end
