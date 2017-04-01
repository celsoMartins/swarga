# frozen_string_literal: true

RSpec.describe Person, type: :model do
  context 'associations' do
    it { is_expected.to belong_to :camping_group }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :camping_group }
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
  end
end
