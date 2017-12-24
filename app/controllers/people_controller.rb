# frozen_string_literal: true

class PeopleController < AuthenticatedController
  before_action :find_camping_group
  before_action :find_person, only: %i[edit update destroy]

  def new
    @person = Person.new(camping_group: @camping_group)
  end

  def create
    @person = Person.new(person_params.merge(camping_group: @camping_group))
    return redirect_to camping_group_path(@camping_group) if @person.save
    render :new
  end

  def edit; end

  def update
    if @person.update(person_params)
      redirect_to camping_group_path(@camping_group, notice: t('people.update.success'))
    else
      render :edit
    end
  end

  def destroy
    @person.delete
    redirect_to camping_group_path(@camping_group, notice: t('people.update.success'))
  end

  private

  def person_params
    params.require(:person).permit(:full_name, :document_number, :phone)
  end

  def find_camping_group
    @camping_group ||= CampingGroup.find(params[:camping_group_id])
  end

  def find_person
    @person = @camping_group.people.find(params[:id])
  end
end
