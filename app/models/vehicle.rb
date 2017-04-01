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
#  fk_rails_960012dc0d  (camping_group_id => camping_groups.id)
#

class Vehicle < ApplicationRecord
  belongs_to :camping_group

  validates :license_plate, :vehicle_type, :camping_group, presence: true

  enum vehicle_type: { car: 0, moto: 1, motor_home: 2 }
end
