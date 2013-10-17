class ScriptLevelsController < ApplicationController
  check_authorization
  load_and_authorize_resource except: :show
  #before_filter :authenticate_user!

  def show
    authorize! :show, ScriptLevel

    @script = Script.find(params[:script_id])
    if params[:id] == ScriptLevel::NEXT
      redirect_to script_level_path(@script, current_user.try(:next_untried_level, @script) || @script.script_levels.first)
      return
    else
      @script_level = ScriptLevel.find(params[:id], include: {level: :game})
    end
    @level = @script_level.level
    @game = @level.game

    @videos = @level.videos

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
    @callouts = Callout.select(:element_id, :text, :qtip_at, :qtip_my)
    @autoplay_video = nil if params[:noautoplay]
    render 'levels/show'
  end
end
