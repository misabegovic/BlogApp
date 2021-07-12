# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reactions::DeleteService do
  let(:user) { create(:user) }
  let(:comment) { create(:comment) }
  let(:not_owned_reaction) { create(:reaction, reaction_type: :like, comment: comment) }
  let(:owned_reaction) { create(:reaction, reaction_type: :like, user: user, comment: comment) }
  let(:expected_data) do
    {
      'action' => :destroy.to_s,
      'type' => :reaction.to_s,
      'reaction_id' => owned_reaction.id,
      'reaction_type' => owned_reaction.reaction_type.to_s,
      'reaction_count' => 0,
      'comment_id' => comment.id,
      'owner_id' => user.id
    }
  end

  describe '#call to delete not owned reaction' do
    context 'expect to be rejected' do
      it_behaves_like 'failed service', ['Unauthorized , you are not the owner of this reaction'] do
        let(:call_result) { described_class.new(not_owned_reaction.id, user.id).call }
      end
    end
  end

  describe '#call to delete owned reaction' do
    context 'expect to succeed' do
      it_behaves_like 'successful service' do
        let(:call_result) { described_class.new(owned_reaction.id, user.id).call }
      end

      it 'broadcasts reaction deleted event with valid data' do
        expect do
          described_class.new(owned_reaction.id, user.id).call
        end.to have_broadcasted_to("post_#{comment.post_id}:comments").with(expected_data)
      end
    end
  end
end
