class HomeController < ApplicationController
  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    redirect_to params[:return_to]
  end

  def check_username
    if !params[:username] || params[:username].length < 5
      render json: { message: "Username must be at least 5 characters", available: false }
    else
      if User.exists?(username: params[:username])
        render json: { message: "Username is already taken", available: false }
      else
        render json: { message: "Available!", available: true }
      end
    end
  end
end
