# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reaction, type: :model do
  context 'db structure' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:comment_id).of_type(:integer) }

    it do
      is_expected.to define_enum_for(:reaction_type)
        .with_values(%i[like thumbs_up smile])
    end

    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:comment) }
  end

  context 'indexs' do
    it { is_expected.to have_db_index(%i[user_id comment_id reaction_type]).unique(true) }
  end
end
