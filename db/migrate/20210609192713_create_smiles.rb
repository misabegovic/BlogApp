# frozen_string_literal: true

class CreateSmiles < ActiveRecord::Migration[6.1]
  def change
    create_table :smiles do |t|
      t.references :comment, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
