# frozen_string_literal: true

RSpec.describe PagesController, type: :controller do
  context 'authenticated' do
    let(:user) { Fabricate :user }
    before { sign_in user }

    describe 'GET #home' do
      before { get :home }
      it { expect(response).to render_template :home }
    end
  end
end
