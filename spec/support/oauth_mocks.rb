module OauthMocks
  def mock_google_auth
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      'provider' => 'google_oauth2',
      'uid' => '123',
      'info' => {
        'email' => 'dude@example.com',
        'name' => 'FN LN',
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret',
      }
    })
  end

  def mock_github_auth
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123',
      'info' => {
        'email' => 'dude@example.com',
        'name' => 'FN LN',
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret',
      }
    })
  end
end
