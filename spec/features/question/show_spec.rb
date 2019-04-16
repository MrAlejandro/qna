require 'rails_helper'

feature 'User can view question with its answers', %q{
  In order to solve his own similar problem
  In order to check if there is a correct answer
} do
  given(:question) { create(:question_with_answers) }

  scenario 'User can view question with answers regardless on authorization' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
