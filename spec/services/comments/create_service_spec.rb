# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comments::CreateService do
  let(:params) do
    {
      description: 'Test'
    }
  end
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe '#call' do
    context 'comment with description' do
      it_behaves_like 'successful service' do
        let(:call_result) { described_class.new(post.id, user.id, params).call }
      end
    end

    context 'comment without description' do
      it_behaves_like 'failed service', ["Description can't be blank"] do
        let(:call_result) { described_class.new(post.id, user.id, {}).call }
      end
    end

    context 'comment with empty description' do
      it_behaves_like 'failed service', ["Description can't be blank"] do
        let(:call_result) { described_class.new(post.id, user.id, { description: '' }).call }
      end
    end
  end
end
