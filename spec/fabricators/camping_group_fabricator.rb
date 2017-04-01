# frozen_string_literal: true

Fabricator(:camping_group) do
  start_date { Time.zone.now }
  end_date { 1.week.from_now }
  tent_number { rand(1..600) }
  price_per_person { [50.0, 18.0, 40.0].sample }
  price_total { [340.0, 70.0, 700.0].sample }
end
