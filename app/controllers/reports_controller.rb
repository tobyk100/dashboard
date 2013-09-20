class ReportsController < ApplicationController
  check_authorization
  before_filter :authenticate_user!

  before_action :set_script

  def user_stats
    @user = User.find_by_id(params[:user_id])
    authorize! :read, @user
    if !@user || !(@user.id == current_user.id || @user.teachers.include?(current_user) || current_user.admin?)
      flash[:alert] = "You don't have access to this person's stats"
      redirect_to root_path
      return
    end

    @concept_progress = @user.concept_progress
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_script
    @script = Script.find(params[:script_id]) if params[:script_id]
  end
end