# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentChannel, type: :channel do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  before do
    stub_connection current_user: user
  end

  describe 'subscribes to a CommentChannel stream' do
    before do
      subscribe post_id: post.id
    end

    it 'expects subscription to be successfull' do
      expect(subscription).to be_confirmed
    end

    it 'expects subscription to stream from post comments' do
      expect(subscription).to have_stream_from("post_#{post.id}:comments")
    end

    it 'expects subscription to stream from post comments for specific user' do
      expect(subscription).to have_stream_from("post_#{post.id}:comments:user_#{user.id}")
    end
  end
end
