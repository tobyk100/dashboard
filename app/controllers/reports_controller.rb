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

    # todo: cache everything but the user's progress
    script_levels  = @user.levels_from_script(@script)
    @concept_progress = Hash.new{|h,k| h[k] = {current: 0, max: 0}}
    script_levels.each do |sl|
      sl.level.concepts.each do |concept|
        @concept_progress[concept][:current] += 1 if sl.user_level.try(:stars).to_i > 0
        @concept_progress[concept][:max] += 1
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_script
    @script = Script.find(params[:script_id]) if params[:script_id]
  end

end