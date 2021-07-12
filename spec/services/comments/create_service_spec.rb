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
  let(:trigger_successfull_request) { described_class.new(post.id, user.id, params).call }
  let(:expected_data) do
    {
      'action' => :create.to_s,
      'comment_id' => Comment.last.id,
      'type' => :comment.to_s
    }
  end

  describe '#call' do
    context 'comment with description' do
      it_behaves_like 'successful service' do
        let(:call_result) { trigger_successfull_request }
      end

      it 'broadcasts comment created event' do
        expect { trigger_successfull_request }.to(have_broadcasted_to("post_#{post.id}:comments").exactly(:once))
      end

      it 'validates broadcasted comment created event' do
        expect { trigger_successfull_request }.to(have_broadcasted_to("post_#{post.id}:comments").with do |data|
                                                    expect(data).to eq expected_data
                                                  end)
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
