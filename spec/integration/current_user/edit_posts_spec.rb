# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Current User - Edit Posts', type: :feature do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }

  before do
    sign_in(user)
  end

  describe 'User lands to edit page successfully' do
    before do
      visit edit_current_user_post_path(post)
    end

    it 'asserts current path' do
      assert_current_path edit_current_user_post_path(post)
    end

    it 'expects to find edit form' do
      expect(page).to have_selector('#edit_post_form')
    end

    it 'expects to find post title on the page' do
      expect(page).to have_content post.title
    end

    it 'expects to find post description on the page' do
      expect(page).to have_content post.description
    end
  end

  describe 'User edits a post successfully' do
    before do
      visit edit_current_user_post_path(post)
      fill_in 'Title', with: 'Title Change'
      fill_in 'Description', with: 'Description Change'
      click_button 'Update'
    end

    it 'asserts current path to be post show page' do
      assert_current_path post_path(Post.last)
    end

    it 'expects not to find edit form' do
      expect(page).not_to have_selector('#edit_post_form')
    end

    it 'expects to find new post title on the page' do
      expect(page).to have_content 'Title Change'
    end

    it 'expects to find new post description on the page' do
      expect(page).to have_content 'Description Change'
    end
  end

  describe 'User fails to edit a post because of missing title' do
    before do
      visit edit_current_user_post_path(post)
      fill_in 'Title', with: ''
      click_button 'Update'
    end

    it 'expects to find edit form' do
      expect(page).to have_selector('#edit_post_form')
    end

    it 'expects to find the error for post title on the page' do
      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'User fails to edit a post because of missing description' do
    before do
      visit edit_current_user_post_path(post)
      fill_in 'Description', with: ''
      click_button 'Update'
    end

    it 'expects to find edit form' do
      expect(page).to have_selector('#edit_post_form')
    end

    it 'expects to find the error for post description on the page' do
      expect(page).to have_content "Description can't be blank"
    end
  end
end
