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


class VehiclesController < AuthenticatedController
  before_action :find_camping_group

  def new
    @new_vehicle = Vehicle.new(camping_group: @camping_group)
  end

  def create
    @new_vehicle = Vehicle.new(vehicle_params.merge(camping_group: @camping_group))
    return redirect_to camping_group_path(@camping_group) if @new_vehicle.save
    render :new
  end

  private

  def vehicle_params
    params.require(:vehicle).permit(:license_plate, :vehicle_type)
  end

  def find_camping_group
    @camping_group ||= CampingGroup.find(params[:camping_group_id])
  end
end
