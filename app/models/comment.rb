# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many :reactions, dependent: :destroy

  validates_presence_of :description

  def user_reacted_by_type?(user, type)
    reactions.where(reaction_type: type).where(user_id: user.id).count.positive?
  end

  def user_reaction_by_type(user, type)
    reactions.where(reaction_type: type).find_by(user_id: user.id)
  end
end
