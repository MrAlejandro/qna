require 'rails_helper'

feature 'User can sign out', %q{
  In order to finish working session
} do
  given(:user) { User.create!(email: 'user@example.com', password: 'secret') }

  scenario 'Signed in user can sign out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
