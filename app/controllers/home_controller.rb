class HomeController < ApplicationController
  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    redirect_to params[:return_to]
  end
end
