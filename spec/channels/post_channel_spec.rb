# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostChannel, type: :channel do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  before do
    stub_connection current_user: user
  end

  describe 'subscribes to a PostChannel stream' do
    before do
      subscribe post_id: post.id
    end

    it 'expects subscription to be successfull' do
      expect(subscription).to be_confirmed
    end

    it 'expects subscription to stream from post' do
      expect(subscription).to have_stream_from("post_#{post.id}")
    end
  end
end
