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
#  fk_rails_e675cba1cd  (camping_group_id => camping_groups.id)
#

class Person < ApplicationRecord
  belongs_to :camping_group

  validates :first_name, :last_name, :camping_group, presence: true
end
