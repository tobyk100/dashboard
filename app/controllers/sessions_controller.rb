class SessionsController < Devise::SessionsController

  before_filter :nonminimal

  # DELETE /resource/sign_out
  # Do not show the flash message after signing out.
  def destroy
    super
    flash[:notice] = ''
  end

end
