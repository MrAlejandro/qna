require 'rails_helper'

feature 'User can delete file attached to a resource', %q{
  In order to remove irrelevant attachment
} do
  describe 'User that owns a resource of' do
    describe 'a question' do
      given(:question) { create(:question, :with_files) }

      background do
        sign_in question.author
        visit question_path(question)
      end

      scenario 'can delete a file attached to a question' do
        within '.question' do
          files = question.files

          files.each do |file|
            expect(page).to have_link file.filename.to_s
          end

          find("#delete_question_file_#{files.last.id}").click

          files.except(files.last) do |file|
            expect(page).to have_link file.filename.to_s
          end

          expect(page).to_not have_link files.last.filename.to_s
        end
      end
    end

    describe 'an answer' do
      given(:answer) { create(:answer, :with_files) }
      given(:question) { create(:question, answers: [answer] ) }

      background do
        sign_in answer.author
        visit question_path(question)
      end

      scenario 'can delete a file attached to an answer' do
        within "#answer_#{answer.id}" do
          files = answer.files

          files.each do |file|
            expect(page).to have_link file.filename.to_s
          end

          find("#delete_answer_file_#{files.last.id}").click

          files.except(files.last) do |file|
            expect(page).to have_link file.filename.to_s
          end
        end
      end
    end
  end

  describe 'User that does not own a resource of' do
    given(:user) { create(:user) }

    background do
      sign_in user
    end

    describe 'a question' do
      given(:question) { create(:question, :with_files) }

      scenario 'cannot remove it' do
        visit question_path(question)

        expect(page).to_not have_selector "#delete_question_file_#{question.files.last.id}"
      end
    end

    describe 'an answer' do
      given(:answer) { create(:answer, :with_files) }
      given(:question) { create(:question, answers: [answer] ) }

      scenario 'cannot remove it' do
        visit question_path(question)

        expect(page).to_not have_selector "#delete_answer_file_#{answer.files.last.id}"
      end
    end
  end
end
