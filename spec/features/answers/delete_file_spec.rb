require 'rails_helper'

feature 'User can delete file attached to answer', %q{
  In order if the attachment is not relevant
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers) }
  given(:first_answer) { question.answers.first }

  background do
    first_answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    first_answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
  end

  scenario 'Question owner can remove attached file', js: true do
    sign_in first_answer.author

    visit question_path(question)

    within "#answer_#{first_answer.id}" do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      find("#delete_answer_file_#{first_answer.files.last.id}").click

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  scenario 'User that not owns the answer cannot remove attached file' do
    sign_in user

    expect(page).to_not have_selector "#delete_answer_file_#{first_answer.files.last.id}"
  end
end
