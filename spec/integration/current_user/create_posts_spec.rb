# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Current User - Create Posts', type: :feature do
  let(:user) { create(:user) }
  let(:post) { build(:post) }

  before do
    sign_in(user)
  end

  describe 'User lands to new post page successfully' do
    before do
      visit new_current_user_post_path
    end

    it 'asserts current path' do
      assert_current_path new_current_user_post_path
    end

    it 'expects to find edit form' do
      expect(page).to have_selector('#create_post_form')
    end
  end

  describe 'User creates a post successfully' do
    before do
      visit new_current_user_post_path
      fill_in 'Title', with: post.title
      fill_in 'Description', with: post.description
      click_button 'Save'
    end

    it 'asserts current path to be post show page' do
      assert_current_path post_path(Post.last)
    end

    it 'expects not to find create form' do
      expect(page).not_to have_selector('#create_post_form')
    end

    it 'expects to find new post title on the page' do
      expect(page).to have_content post.title
    end

    it 'expects to find new post description on the page' do
      expect(page).to have_content post.description
    end
  end

  describe 'User fails to create a post because of missing title' do
    before do
      visit new_current_user_post_path
      fill_in 'Title', with: ''
      fill_in 'Description', with: post.description
      click_button 'Save'
    end

    it 'expects to find create form' do
      expect(page).to have_selector('#create_post_form')
    end

    it 'expects to find the error for post title on the page' do
      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'User fails to create a post because of missing description' do
    before do
      visit new_current_user_post_path
      fill_in 'Title', with: post.title
      fill_in 'Description', with: ''
      click_button 'Save'
    end

    it 'expects to find create form' do
      expect(page).to have_selector('#create_post_form')
    end

    it 'expects to find the error for post description on the page' do
      expect(page).to have_content "Description can't be blank"
    end
  end
end
