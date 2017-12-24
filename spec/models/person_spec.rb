# frozen_string_literal: true

RSpec.describe Person, type: :model do
  context 'associations' do
    it { is_expected.to belong_to :camping_group }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :full_name }
  end
end
