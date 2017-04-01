# frozen_string_literal: true

MoneyRails.configure do |config|
  # set the default currency
  config.default_currency = :brl

  # Custom currency example
  config.register_currency = {
    priority: 1,
    iso_code: 'BRL',
    name: 'Real with subunit of 2 digits',
    symbol: 'R$',
    symbol_first: true,
    subunit: 'Centavos',
    subunit_to_unit: 100,
    thousands_separator: '.',
    decimal_mark: ','
  }
end
