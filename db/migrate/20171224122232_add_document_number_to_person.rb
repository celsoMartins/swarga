# frozen_string_literal: true

class AddDocumentNumberToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :document_number, :string
  end
end
