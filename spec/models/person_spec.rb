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

RSpec.describe Person, type: :model do
  context 'associations' do
    it { is_expected.to belong_to :camping_group }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
  end

  describe '#full_name' do
    let(:person) { Fabricate :person }
    it { expect(person.full_name).to eq "#{person.first_name} #{person.last_name}" }
  end
end
