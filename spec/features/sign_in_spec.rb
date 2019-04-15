require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask question
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { User.create!(email: 'user@example.com', password: 'secret') }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@example.com'
    fill_in 'Password', with: 'secret'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
