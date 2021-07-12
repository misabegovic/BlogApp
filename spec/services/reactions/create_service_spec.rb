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

  describe '#call' do
    context 'like a comment' do
      it_behaves_like 'successful service' do
        let(:call_result) { described_class.new(comment.id, user.id, params).call }
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
