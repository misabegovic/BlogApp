# frozen_string_literal: true

class Smile < ApplicationRecord
  belongs_to :comment
  belongs_to :user
end
