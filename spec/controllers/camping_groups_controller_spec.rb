# frozen_string_literal: true

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
  end

  context 'authenticated' do
    let(:user) { Fabricate :user }
    before { sign_in user }
    let(:person) { Fabricate.build :person }

    describe 'GET #index' do
      context 'having camping groups' do
        let!(:first_camping_group) { Fabricate :camping_group, status: :paid, end_date: Time.zone.tomorrow, people: [person] }
        let!(:second_camping_group) { Fabricate :camping_group, status: :paid, end_date: Time.zone.today, people: [person] }
        let!(:third_camping_group) { Fabricate :camping_group, status: :reserved, end_date: 2.days.from_now, people: [person] }
        let!(:fourth_camping_group) { Fabricate :camping_group, status: :left, people: [person] }

        it 'assigns the instance variable and renders template' do
          get :index
          expect(response).to render_template :index
          expect(assigns[:active_camping_groups]).to eq [second_camping_group, first_camping_group, third_camping_group]
        end
      end
      context 'having no camping groups' do
        before { get :index }
        it { expect(assigns[:active_camping_groups]).to eq [] }
      end
    end

    describe 'GET #new' do
      it 'instatiates the instance variable and renders the template' do
        get :new
        expect(assigns(:new_camping_group)).to be_a_new CampingGroup
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
          expect(assigns(:new_camping_group).errors.full_messages).to eq ['Números das barracas não pode ficar em branco', 'Data de entrada não pode ficar em branco', 'Data de saída não pode ficar em branco']
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
  end
end
