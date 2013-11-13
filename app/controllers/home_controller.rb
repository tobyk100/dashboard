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

  def check_password
    if !params[:password] || params[:password].length < 6
      render json: { message: "Password must be at least 6 characters"}
    else
      render json: { message: "Valid password!"}
    end
  end

  def confirm_password
    if !params[:new_password] || !params[:old_password] ||
        params[:new_password] != params[:old_password]
      render json: { message: "The two passwords you entered do not match."}
    else
      render json: { message: ""}
    end
  end

  def home_insert
    if current_user
      render 'index', layout: false
    else
      render text: ''
    end
  end
end
