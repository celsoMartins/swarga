# frozen_string_literal: true

RSpec.describe CampingGroup, type: :model do
  context 'associations' do
    it { is_expected.to have_many :people }
    it { is_expected.to have_many :vehicles }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :start_date }
    it { is_expected.to validate_presence_of :end_date }
  end

  context 'enums' do
    it { is_expected.to define_enum_for(:status).with(reserved: 0, paid: 1, left: 2) }
  end
end
