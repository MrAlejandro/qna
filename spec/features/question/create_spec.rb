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
      question_attrs = attributes_for(:question)

      fill_in 'Title', with: question_attrs[:title]
      fill_in 'Body', with: question_attrs[:body]
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content question_attrs[:title]
      expect(page).to have_content question_attrs[:title]
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      question_attrs = attributes_for(:question)

      fill_in 'Title', with: question_attrs[:title]
      fill_in 'Body', with: question_attrs[:body]

      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
