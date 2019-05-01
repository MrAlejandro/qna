require 'rails_helper'

feature 'User can delete file attached to question', %q{
  In order if the attachment is not relevant
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
  end

  scenario 'Question owner can remove attached file', js: true do
    sign_in question.author

    visit question_path(question)

    within '.question' do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      find("#delete_question_file_#{question.files.last.id}").click

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  scenario 'User that not owns the question cannot remove attached file' do
    sign_in user

    expect(page).to_not have_selector "#delete_question_file_#{question.files.last.id}"
  end
end
