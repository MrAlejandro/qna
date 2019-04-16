require 'rails_helper'

feature 'User can register', %q{
  In order use all resources available to registered users
} do
  given(:user) { User.create!(email: 'user@example.com', password: 'secret') }

  background { visit new_user_registration_path }

  scenario 'User can register' do
    user_attrs = attributes_for(:user)
    fill_in 'Email', with: user_attrs[:email]
    fill_in 'Password', with: user_attrs[:password]
    fill_in 'Password confirmation', with: user_attrs[:password_confirmation]

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User cannot register if email already exists' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'secret'
    fill_in 'Password confirmation', with: 'secret'

    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'User cannot register with invalid data' do
    fill_in 'Email', with: ''
    fill_in 'Password', with: 'secret'
    fill_in 'Password confirmation', with: 'wrong confirmation'

    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password confirmation doesn't match"
  end
end
