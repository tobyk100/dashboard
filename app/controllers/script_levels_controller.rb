class ScriptLevelsController < ApplicationController
  check_authorization
  include LevelsHelper

  def show
    authorize! :show, ScriptLevel
    @script = Script.find(params[:script_id])

    chapter = params[:chapter]
    script_level_id = params[:id]

    if ScriptLevel::NEXT == (chapter || script_level_id)
      redirect_to build_script_level_path(current_user.try(:next_untried_level, @script) || @script.script_levels.first)
      return
    end

    if chapter
      @script_level = ScriptLevel.where(script: @script, chapter: chapter).first
      raise ActiveRecord::RecordNotFound unless @script_level
    else
      @script_level = ScriptLevel.find(script_level_id)
    end

    present_level(@script_level)
  end

private

  def present_level(script_level)
    @level = script_level.level
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
