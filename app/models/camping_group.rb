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
#  tent_numbers     :integer          not null, is an Array
#  updated_at       :datetime         not null
#

class CampingGroup < ApplicationRecord
  enum status: { reserved: 0, paid: 1, left: 2 }

  has_many :people, dependent: :restrict_with_exception
  has_many :vehicles, dependent: :restrict_with_exception

  validates :tent_numbers, :start_date, :end_date, presence: true

  def calculated_total
    price_per_person * people.count
  end

  def qty_people
    people.count
  end
end
