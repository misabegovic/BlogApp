# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }

  context 'db structure' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments) }
  end

  context 'action cable broadcasts - post update' do
    let(:valid_title_update_data) do
      {
        'action' => :update.to_s,
        'type' => :post.to_s,
        'title' => 'Title Change',
        'description' => post.description
      }
    end
    let(:valid_description_update_data) do
      {
        'action' => :update.to_s,
        'type' => :post.to_s,
        'title' => 'Title Change',
        'description' => post.description
      }
    end

    it 'expects to broadcast post updated message with valid data to post stream' do
      expect do
        post.update({ title: 'Title Change' })
      end.to have_broadcasted_to("post_#{post.id}").with(valid_title_update_data)
    end

    it 'expects to broadcast post updated message with valid data to post comments stream' do
      expect do
        post.update({ title: 'Title Change' })
      end.to have_broadcasted_to("post_#{post.id}:comments").with(valid_title_update_data)
    end

    it 'expects not to broadcast post updated message when title not changed - to post comments stream' do
      expect do
        post.update({ description: 'Description Change' })
      end.not_to have_broadcasted_to("post_#{post.id}:comments").with(valid_description_update_data)
    end
  end

  context 'action cable broadcasts - post delete' do
    let(:valid_delete_update_data) do
      {
        'action' => :destroy.to_s,
        'type' => :post.to_s
      }
    end

    it 'expects to broadcast post updated message with valid data to post stream' do
      expect do
        post.destroy
      end.to have_broadcasted_to("post_#{post.id}").with(valid_delete_update_data)
    end

    it 'expects to broadcast post updated message with valid data to post comments stream' do
      expect do
        post.destroy
      end.to have_broadcasted_to("post_#{post.id}:comments").with(valid_delete_update_data)
    end
  end
end
