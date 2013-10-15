class ReportsController < ApplicationController
  check_authorization except: [:all_usage, :level_stats, :students]
  before_filter :authenticate_user!

  before_action :set_script

  def user_stats
    user = User.find_by_id(params[:user_id])
    authorize! :read, user
    if !user || !(user.id == current_user.id || user.teachers.include?(current_user) || current_user.admin?)
      flash[:alert] = "You don't have access to this person's stats"
      redirect_to root_path
      return
    end
    
    stats user, true
  end
  
  def header_stats
    authorize! :read, current_user
    
    stats current_user, false
  end

  def usage
    # arbitrary way to find admins
    @user = User.find(params[:user_id])
    authorize! :read, @user

    @recent_activities = get_base_usage_activity.where(['user_id = ?', @user.id])
  end

  def all_usage
    raise "unauthorized" if !current_user.admin?

    @recent_activities = get_base_usage_activity
    render 'usage'
  end

  def students
    @recent_activities = current_user.students.blank? ? [] : get_base_usage_activity.where("user_id in (#{current_user.students.map(&:id).join(',')})")
    render 'usage'
  end

  def level_stats
    raise "unauthorized" if !current_user.admin?

    @level = Level.find(params[:level_id])

    best_code_map = Hash.new{|h,k| h[k] = [k, 0] }
    passing_code_map = Hash.new{|h,k| h[k] = [k, 0] }
    finished_code_map = Hash.new{|h,k| h[k] = [k, 0] }
    unsuccessful_code_map = Hash.new{|h,k| h[k] = [k, 0] }

    Activity.all.where(['level_id = ?', @level.id]).order('id desc').limit(1000).each do |activity|
      if activity.best?
        best_code_map[activity.data][1] += 1
      elsif activity.passing?
        passing_code_map[activity.data][1] += 1
      elsif activity.finished?
        finished_code_map[activity.data][1] += 1
      else
        unsuccessful_code_map[activity.data][1] += 1
      end
    end

    @best_code = best_code_map.values.sort_by {|v| -v[1] }
    @passing_code = passing_code_map.values.sort_by {|v| -v[1] }
    @finished_code = finished_code_map.values.sort_by {|v| -v[1] }
    @unsuccessful_code = unsuccessful_code_map.values.sort_by {|v| -v[1] }
  end

  private
  def get_base_usage_activity
    Activity.all.order('id desc').includes([:user, {level: :game}]).limit(50)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_script
    @script = Script.find(params[:script_id]) if params[:script_id]
  end
  
  def stats(user, layout)
    # default to 20-hour script
    @user = user
    @script ||= Script.first
    @concept_progress = @user.concept_progress
    
    render file: "reports/user_stats", layout: layout
  end
end