# frozen_string_literal: true

Fabricator(:person) do
  camping_group
  full_name { Faker::Name.name }
end
