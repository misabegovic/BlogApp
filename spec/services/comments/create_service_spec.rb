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
      it 'will be created' do
        response = described_class.new(post.id, user.id, params).call
        expect(response).to be_success
      end
    end

    context 'comment without description' do
      it 'will not be created' do
        response = described_class.new(post.id, user.id, {}).call
        expect(response).to be_failure
      end
    end

    context 'comment with empty description' do
      it 'will not be created' do
        response = described_class.new(post.id, user.id, { description: '' }).call
        expect(response).to be_failure
      end
    end
  end
end
