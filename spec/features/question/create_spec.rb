require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      question_title = 'Test question'
      question_body = 'Text text text'
      fill_in 'Title', with: question_title
      fill_in 'Body', with: question_body
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content question_title
      expect(page).to have_content question_body
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
