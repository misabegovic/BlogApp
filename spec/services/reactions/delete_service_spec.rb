# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reactions::DeleteService do
  let(:user) { create(:user) }
  let(:not_owned_reaction) { create(:reaction) }
  let(:owned_reaction) { create(:reaction, user: user) }

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
    end
  end
end
