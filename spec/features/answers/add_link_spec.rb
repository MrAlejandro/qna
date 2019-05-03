require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to the answer
  An an author of the answer
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question_with_answers) { create(:question_with_answers) }
  given(:google_link) { {name: 'Google', link: 'https://google.com'} }
  given(:yandex_link) { {name: 'Yandex', link: 'https://yandex.ru'} }
  given(:answer_body) { "Answer to question #{question.id}" }

  scenario 'User adds several links when answers a question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Answer', with: answer_body

    fill_in 'Link name', with: google_link[:name]
    fill_in 'Url', with: google_link[:link]

    click_on 'Add new link for answer'

    all('.form-field-link-name').last.set(yandex_link[:name])
    all('.form-field-link-url').last.set(yandex_link[:link])

    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link google_link[:name], href: google_link[:link]
      expect(page).to have_link yandex_link[:name], href: yandex_link[:link]
    end
  end

  scenario 'User adds link when edits answer', js: true do
    last_answer = question_with_answers.answers.last
    sign_in(last_answer.author)
    visit question_path(question_with_answers)

    within "#answer_#{last_answer.id}" do
      click_on 'Edit'

      click_on 'Add new link for answer'

      fill_in 'Link name', with: google_link[:name]
      fill_in 'Url', with: google_link[:link]

      click_on 'Add new link for answer'

      all('.form-field-link-name').last.set(yandex_link[:name])
      all('.form-field-link-url').last.set(yandex_link[:link])

      click_on 'Save'

      expect(page).to have_link google_link[:name], href: google_link[:link]
      expect(page).to have_link yandex_link[:name], href: yandex_link[:link]
    end
  end
end
