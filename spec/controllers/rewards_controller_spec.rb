require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe 'GET #index' do
    let(:answer) { create(:answer, :best) }
    let(:question) { create(:question, answers: [answer] ) }
    let(:reward) { create(:reward, user: answer.author, question: question) }

    before do
      login(answer.author)
      get :index
    end

    it 'populates an array of all rewards' do
      expect(assigns(:rewards)).to match_array([reward])
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
