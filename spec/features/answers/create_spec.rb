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

    describe 'can add an answer' do
      given(:answer_body) { "Answer to question #{question.id}" }

      background do
        fill_in 'Answer', with: answer_body
      end

      scenario 'with valid data', js: true do
        click_on 'Create answer'

        expect(page).to have_content answer_body
      end

      scenario 'with attached file', js: true do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Create answer'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'cannot add an invalid answer to a question', js: true do
      fill_in 'Url', with: 'tcp://dude.com'
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content "Links url is an invalid URL"
    end

  end

  scenario 'Unauthenticated user cannot add an answer to a question' do
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
