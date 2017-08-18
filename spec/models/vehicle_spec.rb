# frozen_string_literal: true

# == Schema Information
#
# Table name: vehicles
#
#  camping_group_id :integer          not null
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  license_plate    :string           not null
#  updated_at       :datetime         not null
#  vehicle_type     :integer          default("car"), not null
#
# Foreign Keys
#
#  fk_rails_...  (camping_group_id => camping_groups.id)
#

RSpec.describe Vehicle, type: :model do
  context 'associations' do
    it { is_expected.to belong_to :camping_group }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :camping_group }
    it { is_expected.to validate_presence_of :license_plate }
    it { is_expected.to validate_presence_of :vehicle_type }
  end

  context 'enums' do
    it { is_expected.to define_enum_for(:vehicle_type).with(car: 0, moto: 1, motor_home: 2) }
  end
end
