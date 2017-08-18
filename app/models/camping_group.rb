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
  enum status: { reserved: 0, paid: 1, left: 2 }

  has_many :people
  accepts_nested_attributes_for :people, reject_if: :all_blank, allow_destroy: true

  has_many :vehicles
  accepts_nested_attributes_for :vehicles, reject_if: :all_blank, allow_destroy: true

  validates :tent_number, :start_date, :end_date, presence: true
end
