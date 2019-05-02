require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to the question
  An an author of the question
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:link) { 'https://google.com' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    question_attrs = attributes_for(:question)

    fill_in 'Title', with: question_attrs[:title]
    fill_in 'Body', with: question_attrs[:body]

    link_name = 'My link'
    fill_in 'Link name', with: link_name
    fill_in 'Url', with: link

    click_on 'Ask'

    expect(page).to have_link link_name, href: link
  end
end
