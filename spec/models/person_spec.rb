# frozen_string_literal: true

RSpec.describe Person, type: :model do
  context 'associations' do
    it { is_expected.to belong_to :camping_group }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :full_name }
  end

  context 'scopes' do
    let!(:person) { Fabricate :person }
    let!(:other_person) { Fabricate :person }
    let!(:courtesy_person) { Fabricate :person, courtesy: true }
    it { expect(Person.billable).to match_array [person, other_person] }
  end
end
