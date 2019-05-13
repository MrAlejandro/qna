require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:user) { create(:user) }
    let(:comment_attrs) { attributes_for(:comment) }

    context 'authorized user' do
      before { login(user) }

      context 'with valid attributes' do

        context 'by the other user' do
          it 'should be able to add a comment to the question' do
            expect { post :create, params: { question_id: question.id, comment: comment_attrs }, format: :js }
                .to change { question.comments.count }.by(1)
                .and change { user.comments.count }.by(1)
          end

          it 'should be able to add a comment to the answer' do
            expect { post :create, params: { answer_id: answer.id, comment: comment_attrs }, format: :js }
                .to change { answer.comments.count }.by(1)
                .and change { user.comments.count }.by(1)
          end

          it 'renders comment template' do
            post :create, params: { question_id: question.id, comment: comment_attrs }, format: :js
            expect(response).to render_template :create
          end
        end
      end

      context 'with invalid attributes' do
        it 'cannot add a comment' do
          expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment, :invalid) }, format: :js }
              .to_not change { Comment.count }
        end
      end
    end

    context 'unauthorized user' do
      it 'cannot add a comment' do
        expect { post :create, params: { question_id: question.id, comment: comment_attrs }, format: :js }
            .to_not change { Comment.count }
      end
    end
  end

end
