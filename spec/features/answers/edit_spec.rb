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
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'edits this answer', js: true do
      within '.answers' do
        click_on 'Edit'

        new_body = 'edited answer'
        fill_in 'Answer', with: new_body
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content new_body
      end
    end

    scenario 'edits this answer with errors', js: true do
      within '.answers' do
        click_on 'Edit'

        fill_in 'Answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end

      within '.answer-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "Authenticated user tries to edit other user's answer" do
    sign_in create(:user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
