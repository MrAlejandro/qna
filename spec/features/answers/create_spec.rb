require 'rails_helper'

feature 'User can create answer', %q{
  In order to help someone with his problem
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario "can add an answer to a question" do
      answer_body = "Answer to question #{question.id}"
      fill_in 'Answer', with: answer_body
      click_on 'Create answer'

      expect(page).to have_content answer_body
    end

    scenario "cannot add an invalid answer to a question" do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user cannot add an answer to a question" do
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
