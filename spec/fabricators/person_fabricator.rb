# frozen_string_literal: true

Fabricator(:person) do
  camping_group
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
end
