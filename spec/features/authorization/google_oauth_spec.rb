require 'rails_helper'

feature 'User can sign in using google', %q{
  In order to not enter credentials manually
} do
  background do
    visit new_user_session_path
  end

  it 'can sign in user with Google account' do
    mock_google_auth
    click_on 'Sign in with GoogleOauth2'

    expect(page).to have_content 'dude@example.com'
    expect(page).to have_content 'Log out'
  end

  it 'can handle authentication error' do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    click_on 'Sign in with GoogleOauth2'
    expect(page).to have_content 'Could not authenticate you from GoogleOauth2'
  end
end
