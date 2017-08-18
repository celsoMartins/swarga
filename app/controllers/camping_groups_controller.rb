# frozen_string_literal: true

class CampingGroupsController < AuthenticatedController
  def index
    @active_camping_groups = CampingGroup.paid.order(:end_date)
  end

  def new
    @new_camping_group = CampingGroup.new
    @new_camping_group.people.build
    @new_camping_group.vehicles.build
  end

  def create
    @new_camping_group = CampingGroup.new(camping_group_params)
    return redirect_to camping_groups_path if @new_camping_group.save
    @new_camping_group.people.build
    @new_camping_group.vehicles.build
    render :new
  end

  private

  def camping_group_params
    params.require(:camping_group).permit(:tent_number, :price_per_person, :price_total, :start_date, :end_date, people_attributes: %i(first_name last_name phone))
  end
end
