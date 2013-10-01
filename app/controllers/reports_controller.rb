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

    # default to 20-hour script
    @script ||= Script.first
    @concept_progress = @user.concept_progress
  end

  def usage
    # arbitrary way to find admins
    @user = User.find(params[:user_id])
    authorize! :read, @user

    @recent_activities = get_base_usage_activity.where(['user_id = ?', @user.id])
  end

  def all_usage
    # arbitrary way to find admins
    authorize! :destroy, User

    @recent_activities = get_base_usage_activity
    render 'usage'
  end

  def students
    # arbitrary way to find admins
    authorize! :destroy, User

    @recent_activities = get_base_usage_activity.where("user_id in (#{current_user.students.map(&:id).join(',')})")
    render 'usage'
  end

  private
  def get_base_usage_activity
    Activity.all.order('id desc').includes([:user, {level: :game}]).limit(50)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_script
    @script = Script.find(params[:script_id]) if params[:script_id]
  end
end