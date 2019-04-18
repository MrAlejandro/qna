require 'rails_helper'

feature 'User can delete answer', %q{
  In order if it duplicates another answer
} do

  given(:answer) { create(:answer) }

  describe 'Authorized user that owns the answer' do
    background do
      sign_in(answer.author)
      visit question_path(answer.question)
    end

    scenario 'can delete it' do
      expect(page).to have_content answer.body

      click_on 'Delete answer'

      expect(page).to have_content 'Answer has been deleted.'
      expect(page).to_not have_content answer.body
    end
  end

  describe 'Authorized user that does not onw the answer' do
    given(:user) { create(:user) }

    scenario 'cannot delete it' do
      sign_in(user)
      visit question_path(answer.question)

      expect(page).to_not have_link('Delete answer')
    end
  end

  describe 'Unauthorized user' do
    scenario 'cannot delete the answer' do
      visit question_path(answer.question)
      expect(page).to_not have_link('Delete answer')
    end
  end
end
