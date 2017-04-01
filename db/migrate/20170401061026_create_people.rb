# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.integer :camping_group_id, null: false

      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :document
      t.string :phone
      t.integer :price_policy

      t.timestamps
    end

    add_foreign_key :people, :camping_groups, column: :camping_group_id, index: true
  end
end
