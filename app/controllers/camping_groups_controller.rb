# frozen_string_literal: true

class CampingGroupsController < AuthenticatedController
  def index
    @active_camping_groups = CampingGroup.paid.or(CampingGroup.reserved).order(:end_date)
  end

  def new
    @new_camping_group = CampingGroup.new
  end

  def create
    @new_camping_group = CampingGroup.new(camping_group_params.merge(tent_numbers: tent_numbers))
    return redirect_to camping_groups_path if @new_camping_group.save
    render :new
  end

  def show
    @camping_group = CampingGroup.find(params[:id])
  end

  private

  def camping_group_params
    params.require(:camping_group).permit(:tent_numbers, :price_per_person, :price_total, :start_date, :end_date)
  end

  def tent_numbers
    camping_group_params[:tent_numbers].split(',')
  end
end
