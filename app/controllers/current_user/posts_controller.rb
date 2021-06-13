# frozen_string_literal: true

module CurrentUser
  class PostsController < ApplicationController
    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)
      @post.user = current_user

      respond_to do |format|
        if @post.save
          format.html { redirect_to post_path(@post) }
        else
          format.html { render :new }
        end
      end
    end

    def edit
      post
    end

    def update
      respond_to do |format|
        if post.update(post_params)
          format.html { redirect_to post_path(post) }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      post.destroy
      redirect_to user_posts_path(current_user)
    end

    private

    def post
      @post ||= current_user.posts.find(params[:id])
    end

    def post_params
      params.require(:post).permit(
        :title,
        :description
      )
    end
  end
end
