# frozen_string_literal: true
# == Schema Information
#
# Table name: people
#
#  camping_group_id :integer          not null
#  created_at       :datetime         not null
#  document         :string
#  first_name       :string           not null
#  id               :integer          not null, primary key
#  last_name        :string           not null
#  phone            :string
#  price_policy     :integer
#  updated_at       :datetime         not null
#
# Foreign Keys
#
#  fk_rails_...  (camping_group_id => camping_groups.id)
#


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
    params.require(:person).permit(:first_name, :last_name, :phone)
  end

  def find_camping_group
    @camping_group ||= CampingGroup.find(params[:camping_group_id])
  end
end
