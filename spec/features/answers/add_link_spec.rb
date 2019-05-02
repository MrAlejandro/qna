require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to the answer
  An an author of the answer
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:link) { 'https://google.com' }
  given!(:question) { create(:question) }
  given(:answer_body) { "Answer to question #{question.id}" }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Answer', with: answer_body

    link_name = 'My link'
    fill_in 'Link name', with: link_name
    fill_in 'Url', with: link

    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link link_name, href: link
    end
  end
end
