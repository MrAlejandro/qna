require 'rails_helper'

feature 'User can view his rewards' do
  describe 'Authorized user' do
    given(:answer) { create(:answer, :best) }
    given(:question) { create(:question, answers: [answer] ) }
    given!(:reward) { create(:reward, user: answer.author, question: question) }

    scenario 'can view his rewards' do
      sign_in answer.author
      visit root_path

      click_on 'My rewards'

      expect(page).to have_content(question.title)
      expect(page).to have_content(reward.name)
    end
  end
end
