class ScriptLevelsController < ApplicationController
  check_authorization
  load_and_authorize_resource except: :show
  #before_filter :authenticate_user!

  def show
    authorize! :show, ScriptLevel

    @script = Script.find(params[:script_id])
    if params[:id] == ScriptLevel::NEXT
      redirect_to script_level_path(@script, current_user ? current_user.next_untried_level(@script) : @script.script_levels.first)
      return
    else
      @script_level = ScriptLevel.find(params[:id], include: {level: :game})
    end
    @level = @script_level.level
    @game = @level.game
    render 'levels/show'
  end
end