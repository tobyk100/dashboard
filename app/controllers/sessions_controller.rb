class SessionsController < Devise::SessionsController

  before_filter :nonminimal

  # DELETE /resource/sign_out
  # Do not show the flash message after signing out.
  def destroy
    super
    clear_flash_message :notice
  end

  def clear_flash_message(key)
    flash[key] = ''
  end

end
