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

  scope :reserved_active, -> { reserved.where('end_date > ?', Time.zone.today).order(:end_date) }
  scope :paid_active, -> { paid.where('end_date > ?', Time.zone.today).order(:end_date) }
  scope :leaving, -> { where('end_date <= ? AND camping_groups.status <> ?', Time.zone.today, CampingGroup.statuses[:left]).order(:end_date, :start_date) }
  scope :for_term, ->(term) { includes(:people).where('(UPPER(full_name) LIKE :search_name) OR (:search_tent = ANY(tent_numbers))', search_name: "%#{term&.upcase}%", search_tent: term.to_i).references(:people) }

  validates :tent_numbers, :start_date, :end_date, presence: true

  def unpaid_leaving?
    reserved? && end_date <= Time.zone.today
  end

  def calculated_total
    return (price_per_person * people.billable.count) * qty_nights if price_per_person.present?
    price_total
  end

  def qty_people
    people.count
  end

  def qty_nights
    (end_date - start_date).to_i
  end
end
