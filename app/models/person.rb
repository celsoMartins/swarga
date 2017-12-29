# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id               :integer          not null, primary key
#  camping_group_id :integer          not null
#  document         :string
#  phone            :string
#  price_policy     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  document_number  :string
#  full_name        :string           not null
#  courtesy         :boolean          default(FALSE)
#
# Foreign Keys
#
#  fk_rails_...  (camping_group_id => camping_groups.id)
#

class Person < ApplicationRecord
  belongs_to :camping_group, optional: true

  scope :billable, -> { where(courtesy: false) }

  validates :full_name, presence: true
end
