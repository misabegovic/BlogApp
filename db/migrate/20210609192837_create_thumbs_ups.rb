# frozen_string_literal: true

class CreateThumbsUps < ActiveRecord::Migration[6.1]
  def change
    create_table :thumbs_ups do |t|
      t.references :comment, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
