# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comments::DeleteService do
  let(:user) { create(:user) }
  let(:not_owned_comment) { create(:comment) }
  let(:owned_comment) { create(:comment, user: user) }

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
    end
  end
end
