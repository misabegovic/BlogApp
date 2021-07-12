# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comments::DeleteService do
  let(:user) { create(:user) }
  let(:not_owned_comment) { create(:comment) }
  let(:owned_comment) { create(:comment, user: user) }
  let(:expected_data) do
    {
      action: :destroy.to_s,
      type: :comment.to_s,
      comment_id: owned_comment.id
    }
  end

  describe '#call to delete not owned comment' do
    context 'expect to be rejected' do
      it_behaves_like 'failed service', ['Unauthorized , you are not the owner of this comment'] do
        let(:call_result) { described_class.new(not_owned_comment.id, user.id).call }
      end
    end
  end

  describe '#call to delete owned comment' do
    context 'expect to succeed' do
      it_behaves_like 'successful service' do
        let(:call_result) { described_class.new(owned_comment.id, user.id).call }
      end

      it 'broadcasts comment deleted event' do
        expect do
          described_class.new(owned_comment.id, user.id).call
        end.to have_broadcasted_to("post_#{owned_comment.post.id}:comments").exactly(:once).with(expected_data)
      end
    end
  end
end
