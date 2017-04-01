# frozen_string_literal: true

Fabricator(:camping_group) do
  start_date { Time.zone.now }
  end_date { 1.week.from_now }
  tent_number { rand(1..600) }
end
