class FollowersController < ApplicationController
  check_authorization
  load_and_authorize_resource
  before_filter :authenticate_user!

  def create
    target_user = User.find_by_email(params[:email])
    redirect_url = params[:redirect] || root_path

    if target_user
      Follower.create!(user: target_user, student_user: @current_user)

      redirect_to redirect_url, notice: "#{target_user.name} added as your teacher"
    else
      redirect_to redirect_url, notice: "Could not find anyone signed in with '#{params[:email]}'. Please ask them to sign up here and then try adding them again"
    end
  end
end