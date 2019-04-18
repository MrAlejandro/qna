require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user cannot edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    scenario 'edit his question', js: true do
      sign_in question.author
      visit question_path(question)

      within '.question' do
        click_on 'Edit question'

        new_title = 'Edited title'
        new_body = 'Edited body'
        fill_in 'Title', with: new_title
        fill_in 'Body', with: new_body
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content new_title
        expect(page).to have_content new_body
      end
    end

    scenario 'edits this answer with errors'
    scenario "tries to edit other user's answer"
  end
end
