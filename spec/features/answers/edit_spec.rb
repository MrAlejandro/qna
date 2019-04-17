require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user cannot edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits this answer', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      new_body = 'edited answer'
      within '.answers' do
        fill_in 'Answer', with: new_body
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content new_body
      end
    end

    scenario 'edits this answer with errors'
    scenario "tries to edit other user's answer"
  end
end
