# frozen_string_literal: true

# == Schema Information

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

  context 'scopes' do
    describe '.leaving' do
      let!(:leaving) { Fabricate :camping_group, start_date: 1.day.ago, end_date: Time.zone.today }
      let!(:other_leaving) { Fabricate :camping_group, start_date: 3.days.ago, end_date: Time.zone.today }
      let!(:past) { Fabricate :camping_group, start_date: 2.days.ago, end_date: 1.day.ago }
      let!(:future) { Fabricate :camping_group, end_date: 1.day.from_now }
      it { expect(CampingGroup.leaving).to eq [past, other_leaving, leaving] }
    end
  end

  describe '#unpaid_leaving?' do
    context 'when it is unpaid and they are leaving today' do
      let!(:unpaid_leaving) { Fabricate :camping_group, status: :reserved, end_date: Time.zone.today }
      it { expect(unpaid_leaving.unpaid_leaving?).to be true }
    end
    context 'when it is just unpaid and they are not leaving' do
      let!(:unpaid) { Fabricate :camping_group, status: :reserved, end_date: 1.day.from_now }
      it { expect(unpaid.unpaid_leaving?).to be false }
    end
    context 'when it is paid and they are not leaving' do
      let!(:paid) { Fabricate :camping_group, status: :paid, end_date: 1.day.from_now }
      it { expect(paid.unpaid_leaving?).to be false }
    end
  end

  describe '#calculated_total' do
    context 'having people' do
      let(:person) { Fabricate :person }
      let(:other_person) { Fabricate :person }
      let!(:camping_group) { Fabricate :camping_group, price_per_person: 50.0, people: [person, other_person], start_date: Time.zone.today, end_date: 3.days.from_now }
      it { expect(camping_group.calculated_total).to eq 300.0 }
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

  describe '#qty_nights' do
    let!(:camping_group) { Fabricate :camping_group, start_date: 2.days.ago, end_date: Time.zone.today }
    it { expect(camping_group.qty_nights).to eq 2 }
  end
end
