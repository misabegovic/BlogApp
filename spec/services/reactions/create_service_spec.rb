# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reactions::CreateService do
  let(:params) do
    {
      reaction_type: EnumValues::ReactionTypes::LIKE
    }
  end
  let(:user) { create(:user) }
  let(:comment) { create(:comment) }
  let(:trigger_successfull_request) { described_class.new(comment.id, user.id, params).call }
  let(:expected_data) do
    reaction = Reaction.last
    {
      'action' => :create.to_s,
      'type' => :reaction.to_s,
      'reaction_id' => reaction.id,
      'reaction_type' => reaction.reaction_type.to_s,
      'reaction_count' => comment.reactions.where(reaction_type: reaction.reaction_type).count,
      'comment_id' => comment.id,
      'owner_id' => user.id
    }
  end

  describe '#call' do
    context 'like a comment' do
      it_behaves_like 'successful service' do
        let(:call_result) { trigger_successfull_request }
      end

      it 'broadcasts reaction created event' do
        expect do
          trigger_successfull_request
        end.to(have_broadcasted_to("post_#{comment.post.id}:comments").exactly(:once))
      end

      it 'validates broadcasted reaction created event' do
        expect { trigger_successfull_request }.to(have_broadcasted_to("post_#{comment.post.id}:comments").with do |data|
                                                    expect(data).to eq expected_data
                                                  end)
      end
    end

    context 'like already liked comment' do
      let(:reaction) { create(:reaction, comment: comment, user: user) }

      it_behaves_like 'failed service', ['Reaction type has already been taken'] do
        let(:call_result) { described_class.new(reaction.comment.id, reaction.user.id, params).call }
      end
    end
  end
end
