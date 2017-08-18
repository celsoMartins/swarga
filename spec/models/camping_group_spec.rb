# frozen_string_literal: true

RSpec.describe CampingGroup, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:people).dependent(:restrict_with_exception) }
    it { is_expected.to have_many(:vehicles).dependent(:restrict_with_exception) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :tent_numbers }
    it { is_expected.to validate_presence_of :start_date }
    it { is_expected.to validate_presence_of :end_date }
  end

  context 'enums' do
    it { is_expected.to define_enum_for(:status).with(reserved: 0, paid: 1, left: 2) }
  end

  describe '#calculated_total' do
    context 'having people' do
      let(:person) { Fabricate :person }
      let(:other_person) { Fabricate :person }
      let!(:camping_group) { Fabricate :camping_group, price_per_person: 50.0, people: [person, other_person], start_date: Time.zone.today, end_date: 3.days.from_now }
      it { expect(camping_group.calculated_total).to eq 200.0 }
    end
    context 'having no people' do
      let!(:camping_group) { Fabricate :camping_group, price_per_person: 50 }
      it { expect(camping_group.calculated_total).to eq 0 }
    end
  end

  describe '#qty_people' do
    context 'having people' do
      let(:person) { Fabricate :person }
      let(:other_person) { Fabricate :person }
      let!(:camping_group) { Fabricate :camping_group, people: [person, other_person] }
      it { expect(camping_group.qty_people).to eq 2 }
    end
    context 'having no people' do
      let!(:camping_group) { Fabricate :camping_group }
      it { expect(camping_group.qty_people).to eq 0 }
    end
  end
end
