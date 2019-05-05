require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do

    describe 'User that owns' do
      describe 'a question' do
        let(:question) { create(:question_with_links) }

        before { login(question.author) }

        it 'can delete its link' do
          expect { delete :destroy, params: { id: question.links.first } }.to change { question.links.count }.by(-1)
        end

        it 'gets redirect to question page' do
          delete :destroy, params: { id: question.links.first }
          expect(response).to redirect_to question
        end
      end

      describe 'an answer' do
        let(:answer) { create(:answer_with_links) }
        let(:question) { create(:question, answers: [answer]) }

        before { login(answer.author) }

        it 'can delete its links' do
          expect { delete :destroy, params: { id: answer.links.first } }.to change { answer.links.count }.by(-1)
        end

        it 'gets redirect to question page' do
          delete :destroy, params: { id: answer.links.first, redirect_url: question_url(question) }
          expect(response).to redirect_to question
        end
      end
    end

    describe 'User that is not owner of' do
      let(:other_user) { create(:user) }

      before { login(other_user) }

      describe 'a question' do
        let(:question) { create(:question_with_links) }

        it 'cannot delete it' do
          expect { delete :destroy, params: { id: question.links.first.id } }.to_not change { question.links.count }
        end

        it 'gets redirect to question page' do
          delete :destroy, params: { id: question.links.first.id }
          expect(response).to redirect_to question
        end
      end

      describe 'an answer' do
        let(:answer) { create(:answer_with_links) }
        let(:question) { create(:question, answers: [answer]) }

        it 'cannot delete it' do
          expect { delete :destroy, params: { id: answer.links.first.id } }.to_not change { answer.links.count }
        end

        it 'gets redirect to question page' do
          delete :destroy, params: { id: answer.links.first.id, redirect_url: question_path(question) }
          expect(response).to redirect_to question
        end
      end
    end
  end
end
