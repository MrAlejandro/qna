require 'rails_helper'

feature 'User can delete answer', %q{
  In order if it duplicates another answer
} do

  given(:answer) { create(:answer) }

  background do
    sign_in(answer.author)

    visit question_path(answer.question)
  end

  scenario 'User can delete answer that belongs to him' do
    expect(page).to have_content answer.body

    click_on 'Delete answer'

    expect(page).to have_content 'Answer has been deleted.'
    expect(page).to_not have_content answer.body
  end
end
