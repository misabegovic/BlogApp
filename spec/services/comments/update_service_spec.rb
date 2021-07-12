# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comments::UpdateService do
  let(:params) do
    {
      description: 'Test'
    }
  end
  let(:user) { create(:user) }
  let(:not_owned_comment) { create(:comment) }
  let(:owned_comment) { create(:comment, user: user) }

  describe '#call to update not owned comment' do
    context 'expect to be rejected' do
      it_behaves_like 'failed service', ['Unauthorized , you are not the owner of this comment'] do
        let(:call_result) { described_class.new(not_owned_comment.id, user.id, params).call }
      end
    end
  end

  describe '#call to update owned comment' do
    context 'update comment with description' do
      it_behaves_like 'successful service' do
        let(:call_result) { described_class.new(owned_comment.id, user.id, params).call }
      end
    end

    context 'update comment with empty params' do
      it_behaves_like 'successful service' do
        let(:call_result) { described_class.new(owned_comment.id, user.id, {}).call }
      end
    end

    context ' update comment with empty description' do
      it_behaves_like 'failed service', ["Description can't be blank"] do
        let(:call_result) { described_class.new(owned_comment.id, user.id, { description: '' }).call }
      end
    end
  end
end
