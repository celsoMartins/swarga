# frozen_string_literal: true

RSpec.describe PeopleController, type: :controller do
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
          expect(assigns(:new_person)).to be_a_new Person
          expect(assigns(:new_person).camping_group).to eq camping_group
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
          post :create, params: { camping_group_id: camping_group, person: { full_name: 'foo', document_number: '3423', phone: '444' } }
          expect(response).to redirect_to camping_group_path(camping_group)
          created_person = Person.last
          expect(created_person.camping_group).to eq camping_group
          expect(created_person.full_name).to eq 'foo'
          expect(created_person.document_number).to eq '3423'
          expect(created_person.phone).to eq '444'
        end
      end
      context 'with invalid parameters' do
        context 'and passing a valid camping group' do
          it 'does not create the camping group and re-render the form with errors' do
            post :create, params: { camping_group_id: camping_group, person: { foo: 'bar' } }
            expect(response).to render_template :new
            expect(Person.last).to be_nil
            expect(assigns(:new_person).errors.full_messages).to eq ['Nome não pode ficar em branco']
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
