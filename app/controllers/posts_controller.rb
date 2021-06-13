# frozen_string_literal: true

class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end
end
