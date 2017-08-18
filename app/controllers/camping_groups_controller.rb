# frozen_string_literal: true

class CampingGroupsController < AuthenticatedController
  def index
    @reserved_camping_groups = CampingGroup.reserved.order(:end_date)
    @paid_camping_groups = CampingGroup.paid.order(:end_date)
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

  def pay_it
    @camping_group = CampingGroup.find(params[:id])
    @camping_group.paid!
    redirect_to camping_groups_path, notice: t('camping_groups.pay_it.success.message')
  end

  private

  def camping_group_params
    params.require(:camping_group).permit(:tent_numbers, :price_per_person, :price_total, :start_date, :end_date)
  end

  def tent_numbers
    camping_group_params[:tent_numbers].split(',')
  end
end
