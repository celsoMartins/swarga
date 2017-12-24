# frozen_string_literal: true

class PeopleController < AuthenticatedController
  before_action :find_camping_group

  def new
    @new_person = Person.new(camping_group: @camping_group)
  end

  def create
    @new_person = Person.new(person_params.merge(camping_group: @camping_group))
    return redirect_to camping_group_path(@camping_group) if @new_person.save
    render :new
  end

  private

  def person_params
    params.require(:person).permit(:full_name, :document_number, :phone)
  end

  def find_camping_group
    @camping_group ||= CampingGroup.find(params[:camping_group_id])
  end
end
