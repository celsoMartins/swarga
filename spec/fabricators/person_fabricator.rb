# frozen_string_literal: true

Fabricator(:person) do
  camping_group
  full_name { Faker::Name.name }
  document_number { Faker::Number.number }
  courtesy false
end
