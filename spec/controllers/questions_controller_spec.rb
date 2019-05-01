require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { id: question }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    it 'renders new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    it 'renders edit view' do
      get :edit, params: { id: question }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
          .and change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question) }

    describe 'User that owns the question can update it' do
      before { login(question.author) }

      context 'with valid attributes' do
        it 'assigns a requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirects to updated questions' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:invalid_question_params) { attributes_for(:question, :invalid) }

        it 'does not change question' do
          old_title = question.title
          old_body = question.body

          patch :update, params: { id: question, question:  invalid_question_params }, format: :js
          question.reload

          expect(question.title).to eq old_title
          expect(question.body).to eq old_body
        end

        it 're-renders edit view' do
          patch :update, params: { id: question, question:  invalid_question_params }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    describe 'User that does not own the question' do
      it 'cannot update it' do
        login(create(:user))

        old_title = question.title
        old_body = question.body
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq old_title
        expect(question.body).to eq old_body
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'by owner of the question' do
      before { login(question.author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'by other user' do
      before { login(create(:user)) }

      it 'should not delete question that is not belong to customer' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 're-renders show page' do
        delete :destroy, params: { id: question }
        expect(response).to render_template :show
      end
    end
  end

  describe 'DELETE #delete_file' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    before do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    end

    describe 'User that owns the question' do
      before { login(question.author) }

      it 'can delete attached file' do
        expect { delete :delete_file, params: { id: question.id, file_id: question.files.first.id }, format: :js }.to change { question.reload.files.count }.from(1).to(0)
      end

      it 'should render delete_file template' do
        delete :delete_file, params: { id: question.id, file_id: question.files.first.id }, format: :js
        expect(response).to render_template :delete_file
      end
    end

    describe 'User that does not own the question' do
      before { login(user) }

      it 'cannot delete attached file' do
        expect { delete :delete_file, params: { id: question.id, file_id: question.files.first.id }, format: :js }.to_not change { question.reload.files.count }
      end

      it 'should render best template' do
        delete :delete_file, params: { id: question.id, file_id: question.files.first.id }, format: :js
        expect(response).to render_template :delete_file
      end
    end
  end
end
