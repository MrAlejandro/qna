require 'rails_helper'

feature 'User can delete question', %q{
  In order if it duplicates another question
} do

  given(:question) { create(:question) }

  background do
    sign_in(question.author)

    visit question_path(question)
    click_on 'Delete'
  end

  scenario 'User can delete question that belongs to him' do
    expect(page).to have_content 'Question has been deleted.'
  end
end
