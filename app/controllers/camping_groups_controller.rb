# frozen_string_literal: true

class CampingGroupsController < AuthenticatedController
  def index
    @active_camping_groups = CampingGroup.paid.order(:end_date)
  end
end
