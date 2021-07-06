# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :sort_by_created_at, -> { order(created_at: :desc) }
  scope :sort_by_updated_at, -> { order(updated_at: :desc) }
end
