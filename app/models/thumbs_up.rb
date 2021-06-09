# frozen_string_literal: true

class ThumbsUp < ApplicationRecord
  belongs_to :comment
  belongs_to :user
end
