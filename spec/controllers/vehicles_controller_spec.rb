# frozen_string_literal: true

RSpec.describe VehiclesController, type: :controller do
  context 'unauthenticated' do
    describe 'GET #new' do
      before { get :new, params: { camping_group_id: 'foo' } }
      it { expect(response).to redirect_to new_user_session_path }
    end
    describe 'POST #create' do
      before { post :create, params: { camping_group_id: 'foo' } }
      it { expect(response).to redirect_to new_user_session_path }
    end
  end

  context 'authenticated' do
    let(:user) { Fabricate :user }
    before { sign_in user }
    let(:person) { Fabricate.build :person }
    let(:camping_group) { Fabricate :camping_group }

    describe 'GET #new' do
      context 'with a valid camping group' do
        it 'instatiates the instance variable and renders the template' do
          get :new, params: { camping_group_id: camping_group }
          expect(assigns(:new_vehicle)).to be_a_new Vehicle
          expect(assigns(:new_vehicle).camping_group).to eq camping_group
          expect(response).to render_template :new
        end
      end
      context 'with an invalid camping group' do
        before { get :new, params: { camping_group_id: 'foo' } }
        it { expect(response).to be_not_found }
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        it 'creates the camping group as reserved and redirects to index' do
          post :create, params: { camping_group_id: camping_group, vehicle: { license_plate: '234', vehicle_type: 'moto' } }
          expect(response).to redirect_to camping_group_path(camping_group)
          created_vehicle = Vehicle.last
          expect(created_vehicle.camping_group).to eq camping_group
          expect(created_vehicle.license_plate).to eq '234'
          expect(created_vehicle.vehicle_type).to eq 'moto'
        end
      end
      context 'with invalid parameters' do
        context 'and passing a valid camping group' do
          it 'does not create the camping group and re-render the form with errors' do
            post :create, params: { camping_group_id: camping_group, vehicle: { foo: 'bar' } }
            expect(response).to render_template :new
            expect(Vehicle.last).to be_nil
            expect(assigns(:new_vehicle).errors.full_messages).to eq ['Placa não pode ficar em branco']
          end
        end
        context 'and passing an invalid camping group' do
          before { post :create, params: { camping_group_id: 'foo' } }
          it { expect(response).to be_not_found }
        end
      end
    end
  end
end
