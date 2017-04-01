# frozen_string_literal: true

Fabricator(:vehicle) do
  license_plate { Faker::Number.hexadecimal(3) }
  vehicle_type { Vehicle.vehicle_types.values.sample }
end
