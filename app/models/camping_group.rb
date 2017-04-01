# frozen_string_literal: true

# == Schema Information
#
# Table name: camping_groups
#
#  created_at       :datetime         not null
#  end_date         :date             not null
#  id               :integer          not null, primary key
#  price_per_person :decimal(, )
#  price_total      :decimal(, )
#  start_date       :date             not null
#  status           :integer          default("reserved"), not null
#  tent_number      :integer          not null
#  updated_at       :datetime         not null
#

class CampingGroup < ApplicationRecord
  has_many :people
  has_many :vehicles

  validates :start_date, :end_date, presence: true

  enum status: { reserved: 0, paid: 1, left: 2 }
end
