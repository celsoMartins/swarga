# frozen_string_literal: true

class AddCourtesyColumnToPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :courtesy, :boolean, default: false
  end
end
