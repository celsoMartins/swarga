# frozen_string_literal: true
# == Schema Information
#
# Table name: people
#
#  id               :integer          not null, primary key
#  camping_group_id :integer          not null
#  first_name       :string           not null
#  last_name        :string           not null
#  document         :string
#  phone            :string
#  price_policy     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  document_number  :string
#
# Foreign Keys
#
#  fk_rails_...  (camping_group_id => camping_groups.id)
#

class Person < ApplicationRecord
  belongs_to :camping_group, optional: true

  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
