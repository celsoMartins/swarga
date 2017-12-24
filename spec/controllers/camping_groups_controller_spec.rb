# frozen_string_literal: true

# == Schema Information
#
# Table name: camping_groups
#
#  created_at       :datetime         not null
#  end_date         :date             not null
#  id               :integer          not null, primary key
#  price_per_person :decimal(, )
#  price_total      :decimal(, )
#  start_date       :date             not null
#  status           :integer          default("reserved"), not null
#  tent_numbers     :integer          not null, is an Array
#  updated_at       :datetime         not null
#

RSpec.describe CampingGroupsController, type: :controller do
  context 'unauthenticated' do
    describe 'GET #index' do
      before { get :index }
      it { expect(response).to redirect_to new_user_session_path }
    end
    describe 'GET #new' do
      before { get :new }
      it { expect(response).to redirect_to new_user_session_path }
    end
    describe 'POST #create' do
      before { post :create }
      it { expect(response).to redirect_to new_user_session_path }
    end
    describe 'GET #show' do
      before { get :show, params: { id: 'foo' } }
      it { expect(response).to redirect_to new_user_session_path }
    end
    describe 'PATCH #pay_it' do
      before { patch :pay_it, params: { id: 'foo' } }
      it { expect(response).to redirect_to new_user_session_path }
    end
    describe 'PATCH #mark_exit' do
      before { patch :mark_exit, params: { id: 'foo' } }
      it { expect(response).to redirect_to new_user_session_path }
    end
    describe 'GET #edit' do
      before { get :edit, params: { id: 'foo' } }
      it { expect(response).to redirect_to new_user_session_path }
    end
    describe 'PUT #update' do
      before { put :update, params: { id: 'foo' } }
      it { expect(response).to redirect_to new_user_session_path }
    end
  end

  context 'authenticated' do
    let(:user) { Fabricate :user }
    before { sign_in user }
    let(:person) { Fabricate.build :person }

    describe 'GET #index' do
      context 'having camping groups' do
        let!(:first_camping_group) { Fabricate :camping_group, status: :paid, end_date: 2.days.from_now, people: [person] }
        let!(:second_camping_group) { Fabricate :camping_group, status: :paid, end_date: Time.zone.today, people: [person] }
        let!(:third_camping_group) { Fabricate :camping_group, status: :reserved, end_date: 3.days.from_now, people: [person] }
        let!(:fourth_camping_group) { Fabricate :camping_group, status: :left, people: [person] }

        it 'assigns the instance variable and renders template' do
          get :index
          expect(response).to render_template :index
          expect(assigns[:left_camping_groups]).to eq [fourth_camping_group]
          expect(assigns[:last_day_camping_groups]).to eq [second_camping_group]
          expect(assigns[:reserved_camping_groups]).to eq [third_camping_group]
          expect(assigns[:paid_camping_groups]).to eq [second_camping_group, first_camping_group]
        end
      end
      context 'having no camping groups' do
        before { get :index }
        it { expect(assigns[:reserved_camping_groups]).to eq [] }
        it { expect(assigns[:paid_camping_groups]).to eq [] }
      end
    end

    describe 'GET #new' do
      it 'instatiates the instance variable and renders the template' do
        get :new
        expect(assigns(:camping_group)).to be_a_new CampingGroup
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        it 'creates the camping group as reserved and redirects to index' do
          post :create, params: { camping_group: { tent_numbers: 234, price_per_person: 10, price_total: 100, start_date: Time.zone.today, end_date: Time.zone.tomorrow } }
          expect(response).to redirect_to camping_groups_path
          created_camping_group = CampingGroup.last
          expect(created_camping_group.tent_numbers).to eq [234]
          expect(created_camping_group.price_per_person).to eq 10
          expect(created_camping_group.price_total).to eq 100
          expect(created_camping_group.people.count).to eq 0
          expect(created_camping_group.vehicles.count).to eq 0
        end
      end
      context 'with invalid parameters' do
        it 'does not create the camping group and re-render the form with errors' do
          post :create, params: { camping_group: { tent_numbers: nil } }
          expect(response).to render_template :new
          expect(CampingGroup.last).to be_nil
          expect(assigns(:camping_group).errors.full_messages).to eq ['Números das barracas não pode ficar em branco', 'Data de entrada não pode ficar em branco', 'Data de saída não pode ficar em branco']
        end
      end
    end

    describe 'GET #show' do
      context 'with valid parameters' do
        let!(:camping_group) { Fabricate :camping_group }
        it 'creates the camping group as reserved and redirects to index' do
          get :show, params: { id: camping_group }
          expect(response).to render_template :show
          expect(assigns(:camping_group)).to eq camping_group
        end
      end

      context 'with an invalid ID' do
        before { get :show, params: { id: 'foo' } }
        it { expect(response).to be_not_found }
      end
    end

    describe 'PATCH #pay_it' do
      context 'with valid parameters' do
        let!(:camping_group) { Fabricate :camping_group }
        it 'mark as paid and redirects to the camping group list' do
          patch :pay_it, params: { id: camping_group }
          expect(response).to redirect_to camping_groups_path
          expect(flash[:notice]).to eq I18n.t('camping_groups.pay_it.success.message')
          expect(CampingGroup.last).to be_paid
        end
      end

      context 'with an invalid ID' do
        before { patch :pay_it, params: { id: 'foo' } }
        it { expect(response).to be_not_found }
      end
    end
    describe 'PATCH #mark_exit' do
      context 'with valid parameters' do
        let!(:camping_group) { Fabricate :camping_group }
        it 'creates the camping group as reserved and redirects to index' do
          patch :mark_exit, params: { id: camping_group }
          expect(response).to redirect_to camping_groups_path
          expect(flash[:notice]).to eq I18n.t('camping_groups.mark_exit.success.message')
          expect(CampingGroup.last).to be_left
        end
      end

      context 'with an invalid ID' do
        before { patch :mark_exit, params: { id: 'foo' } }
        it { expect(response).to be_not_found }
      end
    end

    describe 'GET #edit' do
      context 'with valid parameters' do
        let!(:camping_group) { Fabricate :camping_group }
        it 'creates the camping group as reserved and redirects to index' do
          get :edit, params: { id: camping_group }
          expect(response).to render_template :edit
          expect(assigns(:camping_group)).to eq camping_group
        end
      end

      context 'with an invalid ID' do
        before { get :edit, params: { id: 'foo' } }
        it { expect(response).to be_not_found }
      end
    end

    describe 'POST #update' do
      context 'with valid parameters' do
        let!(:camping_group) { Fabricate :camping_group }
        it 'updates the camping group and redirects to index' do
          put :update, params: { id: camping_group, camping_group: { tent_numbers: 234, price_per_person: 10, price_total: 100, start_date: Time.zone.today, end_date: Time.zone.tomorrow } }
          expect(response).to redirect_to camping_groups_path
          updated_camping_group = camping_group.reload
          expect(updated_camping_group.tent_numbers).to eq [234]
          expect(updated_camping_group.price_per_person).to eq 10
          expect(updated_camping_group.price_total).to eq 100
          expect(updated_camping_group.people.count).to eq 0
          expect(updated_camping_group.vehicles.count).to eq 0
        end
      end
      context 'with invalid parameters' do
        let!(:camping_group) { Fabricate :camping_group }

        it 'does not update the camping group and re-render the form with errors' do
          put :update, params: { id: camping_group, camping_group: { tent_numbers: nil } }
          expect(response).to render_template :edit
          expect(assigns(:camping_group).errors.full_messages).to eq ['Números das barracas não pode ficar em branco']
        end
      end
    end
  end
end
