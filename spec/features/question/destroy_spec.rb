require 'rails_helper'

feature 'User can delete question', %q{
  In order if it duplicates another question
} do

  given(:question) { create(:question) }

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
