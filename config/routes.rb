# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :current_user do
    resources :posts, only: %i[new create edit update destroy], controller: 'posts'
  end

  resources :users, only: %i[] do
    resources :posts, only: %i[index], controller: 'users/posts'
  end
  resources :posts, only: %i[show], controller: 'posts' do
    resources :comments, only: %i[index create edit update destroy], controller: 'posts/comments'
  end
  resources :comments, only: %i[] do
    resources :reactions, only: %i[create destroy], controller: 'comments/reactions'
  end

  root to: 'home#index'
end
