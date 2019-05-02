require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to the question
  An an author of the question
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:google_link) { {name: 'Google', link: 'https://google.com'} }
  given(:yandex_link) { {name: 'Yandex', link: 'https://yandex.ru'} }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    question_attrs = attributes_for(:question)

    fill_in 'Title', with: question_attrs[:title]
    fill_in 'Body', with: question_attrs[:body]

    fill_in 'Link name', with: google_link[:name]
    fill_in 'Url', with: google_link[:link]

    click_on 'Add new link for question'

    all('.form-field-link-name').last.set(yandex_link[:name])
    all('.form-field-link-url').last.set(yandex_link[:link])

    click_on 'Ask'

    expect(page).to have_link google_link[:name], href: google_link[:link]
    expect(page).to have_link yandex_link[:name], href: yandex_link[:link]
  end
end
