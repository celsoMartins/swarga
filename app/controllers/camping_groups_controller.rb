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

class CampingGroupsController < AuthenticatedController
  def index
    @active_camping_groups = CampingGroup.paid.or(CampingGroup.reserved).order(:end_date)
  end

  def new
    @new_camping_group = CampingGroup.new
    @new_camping_group.people.build
    @new_camping_group.vehicles.build
  end

  def create
    @new_camping_group = CampingGroup.new(camping_group_params.merge(tent_numbers: tent_numbers))
    return redirect_to camping_groups_path if @new_camping_group.save
    @new_camping_group.people.build
    @new_camping_group.vehicles.build
    render :new
  end

  private

  def camping_group_params
    params.require(:camping_group).permit(:tent_numbers, :price_per_person, :price_total, :start_date, :end_date)
  end

  def tent_numbers
    camping_group_params[:tent_numbers].split(',')
  end
end
