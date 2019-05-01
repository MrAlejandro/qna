require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do

    describe 'User that owns the' do
      describe 'a question' do
        let(:question) { create(:question, :with_files) }

        before { login(question.author) }

        it 'can delete its attachment' do
          expect { delete :destroy, params: { id: question.files.first } }.to change { question.files.count }.by(-1)
        end

        it 'gets redirect to question page' do
          delete :destroy, params: { id: question.files.first }
          expect(response).to redirect_to question
        end
      end

      describe 'an answer' do
        let(:answer) { create(:answer, :with_files) }
        let(:question) { create(:question, answers: [answer]) }

        before { login(answer.author) }

        it 'can delete its attachment' do
          expect { delete :destroy, params: { id: answer.files.first } }.to change { answer.files.count }.by(-1)
        end

        it 'gets redirect to question page' do
          delete :destroy, params: { id: answer.files.first, redirect_url: question_url(question) }
          expect(response).to redirect_to question
        end

        it 'should redirect to home page for non existing attachment' do
          delete :destroy, params: { id: 0 }
          expect(response).to redirect_to root_path
        end
      end
    end

    describe 'User that is not owner of' do
      let(:other_user) { create(:user) }

      before { login(other_user) }

      describe 'a question' do
        let(:question) { create(:question, :with_files) }


        it 'cannot delete it' do
          expect { delete :destroy, params: { id: question.files.first.id } }.to_not change { question.files.count }
        end

        it 'gets redirect to question page' do
          delete :destroy, params: { id: question.files.first.id }
          expect(response).to redirect_to question
        end
      end

      describe 'an answer' do
        let(:answer) { create(:answer, :with_files) }
        let(:question) { create(:question, answers: [answer]) }

        it 'cannot delete it' do
          expect { delete :destroy, params: { id: answer.files.first.id } }.to_not change { answer.files.count }
        end

        it 'gets redirect to question page' do
          delete :destroy, params: { id: answer.files.first.id, redirect_url: question_path(question) }
          expect(response).to redirect_to question
        end
      end
    end
  end
end
