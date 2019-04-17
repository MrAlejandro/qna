require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    before { login(user) }

    context 'with valid attributes' do
      let(:params) { { answer: attributes_for(:answer), question_id: question } }

      it 'saves new answer to the database' do
        expect { post :create, params: params, format: :js }.to change(question.answers, :count).by(1)
          .and change(user.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: params, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:params) { { answer: attributes_for(:answer, :invalid), question_id: question } }

      it 'does not save invalid answer to the database' do
        expect { post :create, params: params, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: params, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer) }

    before { login(answer.author) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        new_body = 'New body'
        patch :update, params: { id: answer, answer: { body: new_body } }, format: :js
        answer.reload

        expect(answer.body).to eq new_body
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question_with_answers) }
    let(:first_question) { question.answers.first }

    before do
      login(first_question.author)
    end

    describe 'User that owns the answer' do
      it 'can delete it' do
        expect { delete :destroy, params: { id: first_question.id } }.to change(Answer, :count).by(-1)
      end

      it 'gets redirect to question page' do
        delete :destroy, params: { id: first_question.id }
        expect(response).to redirect_to question_path(question.id)
      end
    end

    describe 'User that is not answer owner' do
      it 'cannot delete it' do
        other_user = create(:user)
        login(other_user)
        expect { delete :destroy, params: { id: first_question.id } }.to_not change(Answer, :count)
      end

      it 'gets redirect to question page' do
        delete :destroy, params: { id: first_question.id }
        expect(response).to redirect_to question_path(question.id)
      end
    end
  end
end
