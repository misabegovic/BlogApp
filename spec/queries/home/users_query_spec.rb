# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Home::UsersQuery, method: :call do
  let(:user) { create(:user) }

  let!(:other_users) { create_list(:user, 2) }

  context 'all users except the one calling the service' do
    subject(:all) { described_class.new(user.id).call }

    it { is_expected.to include(*other_users) }
    it { is_expected.not_to include(user) }
  end
end
