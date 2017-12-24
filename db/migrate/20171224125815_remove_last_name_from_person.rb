# frozen_string_literal: true

class RemoveLastNameFromPerson < ActiveRecord::Migration[5.0]
  def up
    add_column :people, :full_name, :string
    Person.all.each { |p| p.update(full_name: "#{p.first_name.strip} #{p.last_name.strip}") }

    change_column_null :people, :full_name, false

    remove_column :people, :first_name
    remove_column :people, :last_name
  end

  def down
    add_column :people, :first_name, :string
    add_column :people, :last_name, :string

    Person.all.each do |p|
      names = p.full_name.split(' ')
      p.update(first_name: names[0], last_name: (names - %w(names[0])).join(' '))
    end

    change_column_null :people, :first_name, false
    change_column_null :people, :last_name, false

    remove_column :people, :full_name
  end
end
