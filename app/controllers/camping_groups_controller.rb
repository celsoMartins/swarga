# frozen_string_literal: true

class CampingGroupsController < AuthenticatedController
  before_action :find_camping_group, except: %i[index new create]

  def index
    @last_day_camping_groups = CampingGroup.leaving
    @reserved_camping_groups = CampingGroup.reserved_active
    @paid_camping_groups = CampingGroup.paid_active
    @left_camping_groups = CampingGroup.left.order(end_date: :desc)

    perform_search if search_term.present?

    render :index
  end

  def new
    @camping_group = CampingGroup.new
    build_camping_group
  end

  def create
    @camping_group = CampingGroup.new(camping_group_params.merge(tent_numbers: tent_numbers))
    return redirect_to camping_group_path(@camping_group) if @camping_group.save
    build_camping_group
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

  def build_camping_group
    @camping_group.people.build if @camping_group.people.blank?
    @person ||= @camping_group.people.last
    @camping_group.vehicles.build if @camping_group.vehicles.blank?
    @new_vehicle ||= @camping_group.vehicles.last
    @new_vehicle.vehicle_type = nil
  end

  def camping_group_params
    params.require(:camping_group).permit(:tent_numbers, :price_per_person, :price_total, :start_date, :end_date, people_attributes: %i[full_name document_number phone courtesy], vehicles_attributes: %i[license_plate vehicle_type])
  end

  def tent_numbers
    camping_group_params[:tent_numbers].split(',')
  end

  def perform_search
    @last_day_camping_groups = @last_day_camping_groups.for_term(search_term) if search_term.present?
    @reserved_camping_groups = @reserved_camping_groups.for_term(search_term) if search_term.present?
    @paid_camping_groups = @paid_camping_groups.for_term(search_term) if search_term.present?
  end

  def search_term
    @search_term ||= params[:search_term]
  end
end
