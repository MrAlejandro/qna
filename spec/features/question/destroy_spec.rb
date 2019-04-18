require 'rails_helper'

feature 'User can delete question', %q{
  In order if it duplicates another question
} do

  given(:question) { create(:question) }

  describe 'Authorized user that owns the question' do
    background do
      sign_in(question.author)

      visit question_path(question)
    end

    scenario 'User can delete question that belongs to him' do
      expect(page).to have_content question.title
      click_on 'Delete'

      expect(page).to have_content 'Question has been deleted.'
      expect(page).to_not have_content question.title
    end
  end

  describe 'Authorized user that does not onw the question' do
    given(:user) { create(:user) }

    scenario 'cannot delete it' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link('Delete')
    end
  end

  describe 'Unauthorized user' do
    scenario 'cannot delete the answer' do
      visit question_path(question)
      expect(page).to_not have_link('Delete')
    end
  end
end
