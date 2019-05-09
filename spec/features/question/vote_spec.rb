require 'rails_helper'

feature 'User can vote for question', %q{
  In order to show that he likes it
} do
  given!(:question) { create(:question) }

  describe 'Authorized user' do
    given(:user) { create(:user) }

    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'can vote for a question', js: true do
      within '.question' do
        click_on 'Up vote'

        within '.vote-rating' do
          expect(page).to have_content question.rating
        end
      end
    end
  end

  describe 'Non authorized user' do
    background { visit question_path(question) }

    scenario 'cannot vot a question' do
      within '.question' do
        expect(page).to_not have_content 'Up vote'
        expect(page).to_not have_content 'Down vote'
      end
    end
  end

  describe 'The author of the question' do
    background do
      sign_in question.author
      visit question_path(question)
    end

    scenario 'cannot vote for his question' do
      within '.question' do
        expect(page).to_not have_content 'Up vote'
        expect(page).to_not have_content 'Down vote'
      end
    end
  end
end
