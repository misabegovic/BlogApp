# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Posts::CommentsQuery, method: :call do
  let(:post) { create(:post) }
  let(:other_post) { create(:post) }

  let!(:target_comments) { create_list(:comment, 2, post: post) }
  let!(:other_comments) { create_list(:comment, 2, post: other_post) }

  context 'all comments for a specific post' do
    subject(:all) { described_class.new(post.id).call }

    it { is_expected.to include(*target_comments) }
    it { is_expected.not_to include(*other_comments) }
  end
end
