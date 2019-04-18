require 'rails_helper'

feature 'User can select the best answer', %q{
  In order to select answer that helped user with his problem
} do
  given!(:question) { create(:question_with_answers)}
  given(:user) { create(:user) }

  describe 'The owner of the question' do
    background do
      sign_in(question.author)
      visit question_path(question)
    end

    scenario 'can select the best answer (but only on at a time)', js: true do
      last_answer = question.answers.last
      find("#best_answer_#{last_answer.id}").click

      within '.answer.best-answer' do
        expect(page).to have_content(last_answer.body)
      end

      first_answer = question.answers.first
      find("#best_answer_#{first_answer.id}").click

      within '.answer.best-answer' do
        expect(page).to_not have_content(last_answer.body)
        expect(page).to have_content(first_answer.body)
      end
    end
  end

  scenario 'Any user will see the best answer at the top of the page' do
    best_answer = create(:answer, best: true)
    question_with_best_answer = create(:question, answers: create_list(:answer, 3) << best_answer)
    visit question_path(question_with_best_answer)

    within '.answers .answer:nth-child(1)' do
      expect(page).to have_content(best_answer.body)
    end
  end

  scenario 'The user that does not own the question cannot select the best answer' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'Best'
  end
end
