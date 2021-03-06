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

    describe 'User that owns the answer can update it' do
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

    describe 'User that does not own the answer' do
      it 'cannot update it' do
        login(create(:user))

        old_body = answer.body
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to eq old_body
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
        expect { delete :destroy, params: { id: first_question.id }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'gets destroy template rendered' do
        delete :destroy, params: { id: first_question.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    describe 'User that is not answer owner' do
      it 'cannot delete it' do
        other_user = create(:user)
        login(other_user)
        expect { delete :destroy, params: { id: first_question.id }, format: :js }.to_not change(Answer, :count)
      end

      it 'gets destroy template rendered' do
        delete :destroy, params: { id: first_question.id }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #best' do
    let(:question) { create(:question_with_answers) }
    let(:last_answer) { question.answers.last }
    let(:first_answer) { question.answers.first }
    let(:user) { create(:user) }

    describe 'User that owns the question' do
      before do
        login(question.author)
      end

      it 'can select best answer' do
        expect { patch :best, params: { id: last_answer.id }, format: :js }.to change { last_answer.reload.best }.from(false).to(true)
      end

      it 'can select only one best answer at a time' do
        patch :best, params: { id: last_answer.id }, format: :js
        last_answer.reload

        expect { patch :best, params: { id: first_answer.id }, format: :js }.to change { first_answer.reload.best }.from(false).to(true)
          .and change { last_answer.reload.best }.from(true).to(false)
      end

      it 'should render best template' do
        patch :best, params: { id: last_answer.id }, format: :js
        expect(response).to render_template :best
      end
    end

    describe 'User that does not own the question' do
      before { login(user) }

      it 'cannot select the best answer' do
        expect { patch :best, params: { id: last_answer.id }, format: :js }.to_not change { last_answer.reload.best }
      end

      it 'should render best template' do
        patch :best, params: { id: last_answer.id }, format: :js
        expect(response).to render_template :best
      end
    end
  end

  describe 'POST #upvote' do
    let!(:answer) { create(:answer) }

    context 'by the other user' do
      before { login(create(:user)) }

      it 'should be able to upvote the answer' do
        expect { post :upvote, params: { id: answer }, format: :json }.to change{ answer.upvotes.count }.by(1)
      end

      it 'should respond with json' do
        post :upvote, params: { id: answer }, format: :json
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'by the non-authorized user' do
      it 'should not be able to upvote the answer' do
        expect { post :upvote, params: { id: answer }, format: :json }.to_not change{ answer.upvotes.count }
      end
    end

    context 'by the answer author' do
      before { login(answer.author) }

      it 'should not be able to upvote the answer' do
        expect { post :upvote, params: { id: answer }, format: :json }.to_not change{ answer.upvotes.count }
      end
    end
  end

  describe 'POST #downvote' do
    let!(:answer) { create(:answer) }

    context 'by the other user' do
      before { login(create(:user)) }

      it 'should be able to downvote the answer' do
        expect { post :downvote, params: { id: answer }, format: :json }.to change{ answer.downvotes.count }.by(1)
      end

      it 'should respond with json' do
        post :downvote, params: { id: answer }, format: :json
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
