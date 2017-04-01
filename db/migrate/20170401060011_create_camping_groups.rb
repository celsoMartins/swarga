# frozen_string_literal: true

class CreateCampingGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :camping_groups do |t|
      t.integer :tent_number, null: false
      t.integer :status, null: false, default: 0
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.decimal :price_per_person
      t.decimal :price_total

      t.timestamps
    end
  end
end
