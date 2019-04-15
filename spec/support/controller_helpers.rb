module ControllerHelpers
  def login(user)
    @request.env['device.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end
end
