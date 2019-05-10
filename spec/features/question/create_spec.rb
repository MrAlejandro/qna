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

    describe 'can ask a question' do
      given(:question_attrs) { attributes_for(:question) }

      background do
        fill_in 'Title', with: question_attrs[:title]
        fill_in 'Body', with: question_attrs[:body]
      end

      scenario 'with valid data' do
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content question_attrs[:title]
        expect(page).to have_content question_attrs[:body]
      end

      scenario 'with attached file' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'with reward for the best answer' do
        reward_name = 'Major'
        fill_in 'Reward name', with: reward_name
        attach_file 'Reward image', "#{Rails.root}/spec/fixtures/image.png"

        click_on 'Ask'

        expect(page).to have_content "You will get the '#{reward_name}' reward for the best answer."
      end
    end

    scenario 'asks a question with errors' do
      fill_in 'Url', with: 'tcp://dude.com'
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Links url is an invalid URL"
    end
  end

  describe 'Multiple sessions' do
    given(:question_attrs) { attributes_for(:question) }

    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit new_question_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        fill_in 'Title', with: question_attrs[:title]
        fill_in 'Body', with: question_attrs[:body]

        click_on 'Ask'

        expect(page).to have_content question_attrs[:title]
        expect(page).to have_content question_attrs[:body]
      end

      Capybara.using_session('guest') do
        expect(page).to have_content question_attrs[:title]
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
