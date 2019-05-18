require 'rails_helper'

feature 'User can sign in using github', %q{
  In order to not enter credentials manually
} do
  background { visit new_user_session_path }
  it 'can sign in user with Google account' do
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'dude@example.com'
    expect(page).to have_content 'Log out'
  end

  it 'can handle authentication error' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Could not authenticate you from GitHub'
  end
end
