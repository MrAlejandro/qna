require 'rails_helper'

feature 'User can add a comment for a question', %q{
  In order to to clarify some information
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authorized user' do
    given(:comment_attrs) { attributes_for(:comment) }

    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'can add a comment to the question', js: true do
      within '.question-comments' do
        fill_in 'Comment', with: comment_attrs[:body]
        click_on 'Add comment'

        within '.comments' do
          expect(page).to have_content comment_attrs[:body]
        end
      end
    end

    scenario 'should see an error when adding comment with empty body', js: true do
      within '.question-comments' do
        fill_in 'Comment', with: ''
        click_on 'Add comment'

        within '.comments-errors' do
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end

  describe 'Multiple sessions' do
    given(:comment_attrs) { attributes_for(:comment) }

    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question-comments' do
          fill_in 'Comment', with: comment_attrs[:body]
          click_on 'Add comment'

          within '.comments' do
            expect(page).to have_content comment_attrs[:body]
          end
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content comment_attrs[:body]
      end
    end
  end

  describe 'Non authorized user' do
    background { visit question_path(question) }

    scenario 'cannot add a comment to a question' do
      within '.question-comments' do
        expect(page).to_not have_button 'Add comment'
      end
    end
  end
end
