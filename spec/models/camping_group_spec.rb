# frozen_string_literal: true

# == Schema Information

RSpec.describe CampingGroup, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:people).dependent(:restrict_with_exception) }
    it { is_expected.to have_many(:vehicles).dependent(:restrict_with_exception) }
  end

  context 'validations' do
    context 'simple ones' do
      it { is_expected.to validate_presence_of :tent_numbers }
      it { is_expected.to validate_presence_of :start_date }
      it { is_expected.to validate_presence_of :end_date }
    end
    context 'complex ones' do
      describe 'some_price_present?' do
        context 'having no price defined' do
          let(:camping_group) { Fabricate.build :camping_group, price_per_person: nil, price_total: nil }
          it 'expect to not be valid' do
            expect(camping_group.valid?).to be false
            expect(camping_group.errors[:price_per_person]).to eq [I18n.t('camping_group.validations.no_price')]
            expect(camping_group.errors[:price_total]).to eq [I18n.t('camping_group.validations.no_price')]
          end
        end
        context 'having price_total defined' do
          let(:camping_group) { Fabricate.build :camping_group, price_per_person: nil, price_total: 10 }
          it { expect(camping_group.valid?).to be true }
        end
        context 'having price_per_person defined' do
          let(:camping_group) { Fabricate.build :camping_group, price_per_person: 10, price_total: nil }
          it { expect(camping_group.valid?).to be true }
        end
      end
    end
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

    describe '.reserved_active' do
      let!(:reserved) { Fabricate :camping_group, status: :reserved, start_date: 1.day.ago, end_date: 2.days.from_now }
      let!(:other_reserved) { Fabricate :camping_group, status: :reserved, start_date: 3.days.ago, end_date: 1.day.from_now }
      let!(:reserved_past) { Fabricate :camping_group, status: :reserved, start_date: 2.days.ago, end_date: 1.day.ago }
      let!(:reserved_now) { Fabricate :camping_group, status: :reserved, end_date: Time.zone.today }
      it { expect(CampingGroup.reserved_active).to eq [other_reserved, reserved] }
    end

    describe '.paid_active' do
      let!(:reserved) { Fabricate :camping_group, status: :paid, start_date: 1.day.ago, end_date: 2.days.from_now }
      let!(:other_reserved) { Fabricate :camping_group, status: :paid, start_date: 3.days.ago, end_date: 1.day.from_now }
      let!(:reserved_past) { Fabricate :camping_group, status: :paid, start_date: 2.days.ago, end_date: 1.day.ago }
      let!(:reserved_now) { Fabricate :camping_group, status: :paid, end_date: Time.zone.today }
      it { expect(CampingGroup.paid_active).to eq [other_reserved, reserved] }
    end

    describe '.for_term' do
      context 'search by name' do
        let(:person) { Fabricate.build :person, full_name: 'test name' }
        let(:other_person) { Fabricate.build :person, full_name: 'other name' }
        let!(:reserved) { Fabricate :camping_group, status: :reserved, start_date: 1.day.ago, end_date: 2.days.from_now, people: [person] }
        let!(:paid) { Fabricate :camping_group, status: :paid, start_date: 1.day.ago, end_date: 2.days.from_now, people: [other_person] }
        it { expect(CampingGroup.for_term('tEsT')).to eq [reserved] }
        it { expect(CampingGroup.for_term('oTHer')).to eq [paid] }
      end
      context 'search by tent_number' do
        let!(:tent_21_30) { Fabricate :camping_group, tent_numbers: [21, 30] }
        let!(:tent_40_50) { Fabricate :camping_group, tent_numbers: [40, 50] }
        it { expect(CampingGroup.for_term('21')).to eq [tent_21_30] }
        it { expect(CampingGroup.for_term('50')).to eq [tent_40_50] }
      end
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
      let(:courtesy_person) { Fabricate :person, courtesy: true }
      let!(:camping_group) { Fabricate :camping_group, price_per_person: 50.0, people: [person, other_person, courtesy_person], start_date: Time.zone.today, end_date: 3.days.from_now }
      it { expect(camping_group.calculated_total).to eq 300.0 }
    end
    context 'having no people' do
      let!(:camping_group) { Fabricate :camping_group, price_per_person: 50 }
      it { expect(camping_group.calculated_total).to eq 0 }
    end
    context 'having price_total' do
      let!(:camping_group) { Fabricate :camping_group, price_per_person: nil, price_total: 200 }
      it { expect(camping_group.calculated_total).to eq 200 }
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
