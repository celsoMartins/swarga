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
    describe 'GET #edit' do
      before { get :edit, params: { camping_group_id: 'foo', id: 'bar' } }
      it { expect(response).to redirect_to new_user_session_path }
    end
    describe 'PUT #update' do
      before { put :update, params: { camping_group_id: 'foo', id: 'bar' } }
      it { expect(response).to redirect_to new_user_session_path }
    end
    describe 'DELETE #destroy' do
      before { delete :destroy, params: { camping_group_id: 'foo', id: 'bar' } }
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
          expect(assigns(:person)).to be_a_new Person
          expect(assigns(:person).camping_group).to eq camping_group
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
        context 'and passing a valid camping group and invalid person' do
          it 'does not create the camping group and re-render the form with errors' do
            post :create, params: { camping_group_id: camping_group, person: { foo: 'bar' } }
            expect(response).to render_template :new
            expect(Person.last).to be_nil
            expect(assigns(:person).errors.full_messages).to eq ['Nome não pode ficar em branco']
          end
        end
        context 'and passing an invalid camping group' do
          before { post :create, params: { camping_group_id: 'foo' } }
          it { expect(response).to be_not_found }
        end
      end
    end
    describe 'GET #edit' do
      let(:person) { Fabricate :person, camping_group: camping_group }
      context 'with a valid camping group' do
        context 'and a valid person' do
          it 'finds the person and renders the template' do
            get :edit, params: { camping_group_id: camping_group, id: person }
            expect(assigns(:person)).to eq person
            expect(response).to render_template :edit
          end
        end
        context 'and an invalid person' do
          before { get :edit, params: { id: 'foo', camping_group_id: camping_group } }
          it { expect(response).to be_not_found }
        end
      end
      context 'with an invalid camping group' do
        before { get :edit, params: { id: person, camping_group_id: 'foo' } }
        it { expect(response).to be_not_found }
      end
    end

    describe 'PUT #update' do
      let(:person) { Fabricate :person, camping_group: camping_group }

      context 'with valid parameters' do
        context 'and a valid person' do
          it 'updates the camping group as reserved and redirects to index' do
            put :update, params: { camping_group_id: camping_group, id: person, person: { full_name: 'foo', document_number: '3423', phone: '444' } }
            expect(response).to redirect_to camping_group_path(camping_group, notice: I18n.t('people.update.success'))
            updated_person = Person.last
            expect(updated_person.camping_group).to eq camping_group
            expect(updated_person.full_name).to eq 'foo'
            expect(updated_person.document_number).to eq '3423'
            expect(updated_person.phone).to eq '444'
          end
        end
      end
      context 'with invalid parameters' do
        context 'and passing a valid camping group and invalid person' do
          it 'does not update the camping group and re-render the form with errors' do
            put :update, params: { camping_group_id: camping_group, id: person, person: { full_name: nil } }
            expect(response).to render_template :edit
            expect(assigns(:person).errors.full_messages).to eq ['Nome não pode ficar em branco']
          end
          context 'and an invalid person' do
            before { get :edit, params: { id: 'foo', camping_group_id: camping_group } }
            it { expect(response).to be_not_found }
          end
        end
        context 'and passing an invalid camping group' do
          before { put :update, params: { camping_group_id: 'foo', id: person } }
          it { expect(response).to be_not_found }
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:person) { Fabricate :person, camping_group: camping_group }
      context 'with a valid camping group' do
        context 'and a valid person' do
          it 'finds the person and renders the template' do
            delete :destroy, params: { camping_group_id: camping_group, id: person }
            expect(Person.last).to be_nil
          end
        end
        context 'and an invalid person' do
          before { delete :destroy, params: { id: 'foo', camping_group_id: camping_group } }
          it { expect(response).to be_not_found }
        end
      end
      context 'with an invalid camping group' do
        before { delete :destroy, params: { id: person, camping_group_id: 'foo' } }
        it { expect(response).to be_not_found }
      end
    end
  end
end
