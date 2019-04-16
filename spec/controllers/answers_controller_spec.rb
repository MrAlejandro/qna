require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }

    before { login(user) }

    context 'with valid attributes' do
      let(:question) { create(:question) }
      let(:params) { { answer: attributes_for(:answer), question_id: question } }

      it 'saves new answer to the database' do
        expect { post :create, params: params }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question page' do
        post :create, params: params
        expect(response).to redirect_to question_path(params[:question_id])
      end
    end

    context 'with invalid attributes' do
      let(:question) { create(:question) }
      let(:params) { { answer: attributes_for(:answer, :invalid), question_id: question } }

      it 'does not save invalid answer to the database' do
        expect { post :create, params: params }.to_not change(Answer, :count)
      end

      it 'redirects to question page' do
        post :create, params: params
        expect(response).to redirect_to question_path(params[:question_id])
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer) }
    let(:question) { create(:question) }

    before do
      login(answer.author)
      question.answers = [answer]
      question.save
    end

    describe 'User that owns the answer' do
      it 'can delete it' do
        expect { delete :destroy, params: { id: answer.id } }.to change(question.answers, :count).by(-1)
      end

      it 'gets redirect to question page' do
        delete :destroy, params: { id: answer.id }
        expect(response).to redirect_to question_path(question.id)
      end
    end

    it 'User that does not own the answer cannot delete it' do
      other_user = create(:user)
      login(other_user)
      expect { delete :destroy, params: { id: answer.id } }.to_not change(question.answers, :count)
    end
  end
end
