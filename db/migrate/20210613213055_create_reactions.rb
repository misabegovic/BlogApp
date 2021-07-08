# frozen_string_literal: true

class CreateReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :reactions do |t|
      t.references :comment, foreign_key: true
      t.references :user, foreign_key: true

      t.integer :reaction_type, default: 0

      t.timestamps
    end

    add_index :reactions, %i[user_id comment_id reaction_type], unique: true
  end
end
