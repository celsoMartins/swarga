# frozen_string_literal: true

class CampingGroupsController < AuthenticatedController
  before_action :find_camping_group, except: %i[index new create]

  def index
    @last_day_camping_groups = CampingGroup.leaving.for_term(search_term)
    @reserved_camping_groups = CampingGroup.reserved.for_term(search_term) - @last_day_camping_groups
    @paid_camping_groups = CampingGroup.paid.for_term(search_term).order(:end_date) - @last_day_camping_groups
    @left_camping_groups = CampingGroup.left.order(end_date: :desc)
    render :index
  end

  def new
    @camping_group = CampingGroup.new
  end

  def create
    @camping_group = CampingGroup.new(camping_group_params.merge(tent_numbers: tent_numbers))
    return redirect_to camping_groups_path if @camping_group.save
    render :new
  end

  def pay_it
    @camping_group.paid!
    redirect_to camping_groups_path, notice: t('camping_groups.pay_it.success.message')
  end

  def find_camping_group
    @camping_group = CampingGroup.find(params[:id])
  end

  def mark_exit
    @camping_group.left!
    redirect_to camping_groups_path, notice: t('camping_groups.mark_exit.success.message')
  end

  def update
    @camping_group.update(camping_group_params.merge(tent_numbers: tent_numbers))
    return redirect_to camping_groups_path if @camping_group.save
    render :edit
  end

  private

  def camping_group_params
    params.require(:camping_group).permit(:tent_numbers, :price_per_person, :price_total, :start_date, :end_date)
  end

  def tent_numbers
    camping_group_params[:tent_numbers].split(',')
  end

  def search_term
    @search_term ||= params[:search_term]
  end
end
