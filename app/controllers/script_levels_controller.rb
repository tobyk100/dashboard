class ScriptLevelsController < ApplicationController
  check_authorization
  load_and_authorize_resource except: :show
  #before_filter :authenticate_user!

  def show
    authorize! :show, ScriptLevel

    @script = Script.find(params[:script_id])
    if params[:id] == ScriptLevel::NEXT
      redirect_to view_context.build_script_level_path(current_user ? current_user.next_untried_level(@script) : @script.script_levels.first)
      return
    else
      @script_level = ScriptLevel.find(params[:id], include: {level: :game})
    end
    @level = @script_level.level
    @game = @level.game

    @videos = []
    @videos << @game.intro_video if @game.intro_video
    #@videos << @script.wrapup_video if @script.wrapup_video
    @level.concepts.each do |concept|
      @videos << concept.video if concept.video
    end

    # todo: make this based on which videos the user/session has already seen
    seen = session[:videos_seen] || Set.new()
    @videos.each do |v|
      if !seen.include?(v.key)
        @autoplay_video = v
        seen.add(v.key)
        session[:videos_seen] = seen
        break
      end
    end

    @callback = milestone_url(user_id: current_user.try(:id) || 0, script_level_id: @script_level)
    @full_width = true
    render 'levels/show'
  end
end
