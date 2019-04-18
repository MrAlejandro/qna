require 'rails_helper'

feature 'User can view questions list', %q{
  In order to help somebody with answer
  In order to find similar problem with solution
} do

  scenario 'Unauthenticated user can view questions list' do
    questions = create_list(:question, 3)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
