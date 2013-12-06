class SessionsController < Devise::SessionsController

  before_filter :nonminimal

  # DELETE /resource/sign_out
  # Do not show the flash message after signing out.
  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    yield resource if block_given?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end

end
