require 'rails_helper'

feature 'User can delete link attached to a resource', %q{
  In order to remove irrelevant link
} do
  describe 'User that owns a resource of' do
    describe 'a question' do
      given(:question) { create(:question_with_links) }

      background do
        sign_in question.author
        visit question_path(question)
      end

      scenario 'can delete a link attached to a question' do
        within '.question' do
          links = question.links

          links.each do |link|
            expect(page).to have_link link.name, href: link.url
          end

          last_link = links.last
          find("#delete_question_link_#{last_link.id}").click

          links.except(last_link) do |link|
            expect(page).to have_link link.name, href: link.url
          end

          expect(page).to_not have_link last_link.name, href: last_link.url
        end
      end
    end

    describe 'an answer' do
      given(:answer) { create(:answer_with_links) }
      given(:question) { create(:question, answers: [answer] ) }

      background do
        sign_in answer.author
        visit question_path(question)
      end

      scenario 'can delete a file attached to an answer' do
        within "#answer_#{answer.id}" do
          links = answer.links

          links.each do |link|
            expect(page).to have_link link.name, href: link.url
          end

          last_link = links.last
          find("#delete_answer_link_#{last_link.id}").click

          links.except(links.last) do |link|
            expect(page).to have_link link.name, href: link.url
          end

          expect(page).to_not have_link last_link.name, href: last_link.url
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
      given(:question) { create(:question_with_links) }

      scenario 'cannot remove it' do
        visit question_path(question)

        expect(page).to_not have_selector "#delete_question_link_#{question.links.last.id}"
      end
    end

    describe 'an answer' do
      given(:answer) { create(:answer_with_links) }
      given(:question) { create(:question, answers: [answer] ) }

      scenario 'cannot remove it' do
        visit question_path(question)

        expect(page).to_not have_selector "#delete_answer_link_#{answer.links.last.id}"
      end
    end
  end
end
