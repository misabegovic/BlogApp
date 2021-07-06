# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @users = Home::UsersQuery.new(current_user.id).call
  end
end
