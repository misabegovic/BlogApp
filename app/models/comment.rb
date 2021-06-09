# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :smiles, dependent: :destroy
  has_many :thumbs_ups, dependent: :destroy
end
