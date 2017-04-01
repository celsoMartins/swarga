# frozen_string_literal: true

class CreateVehicles < ActiveRecord::Migration[5.0]
  def change
    create_table :vehicles do |t|
      t.integer :camping_group_id, null: false

      t.string :license_plate, null: false
      t.integer :vehicle_type, null: false, default: 0

      t.timestamps
    end

    add_foreign_key :vehicles, :camping_groups, column: :camping_group_id, index: true
  end
end
