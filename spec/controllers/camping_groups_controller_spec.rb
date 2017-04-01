# frozen_string_literal: true

RSpec.describe CampingGroupsController, type: :controller do
  context 'unauthenticated' do
    describe 'GET #index' do
      before { get :index }
      it { expect(response).to redirect_to new_user_session_path }
    end
  end

  context 'authenticated' do
    let(:user) { Fabricate :user }
    before { sign_in user }

    context 'having camping group' do
      let!(:first_camping_group) { Fabricate :camping_group, status: :paid, end_date: Time.zone.tomorrow }
      let!(:second_camping_group) { Fabricate :camping_group, status: :paid, end_date: Time.zone.today }
      let!(:third_camping_group) { Fabricate :camping_group, status: :reserved }
      let!(:fourth_camping_group) { Fabricate :camping_group, status: :left }

      it 'assigns the instance variable and renders template' do
        get :index
        expect(response).to render_template :index
        expect(assigns[:active_camping_groups]).to eq [second_camping_group, first_camping_group]
      end
    end
  end
end
