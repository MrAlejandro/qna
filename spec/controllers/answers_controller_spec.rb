require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
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
end
