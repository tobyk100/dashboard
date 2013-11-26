class ScriptLevelsController < ApplicationController
  check_authorization
  include LevelsHelper

  def show
    authorize! :show, ScriptLevel
    @script = Script.find(params[:script_id])

    chapter = params[:chapter]
    script_level_id = params[:id]
    reset = params[:reset]

    if reset
      # reset is a special mode which will delete the session if the user is not signed in
      # and start them at the beginning of the script.
      # If the user is signed in, continue normally
      reset_session if !current_user
      redirect_to build_script_level_path(@script.script_levels.first)
      return
    end

    if ScriptLevel::NEXT == (chapter || script_level_id)
      if current_user
        redirect_to build_script_level_path(current_user.try(:next_untried_level, @script) || @script.script_levels.first)
      else
        session_progress = session[:progress] || {}

        @script.script_levels.each do |sl|
          if session_progress.fetch(sl.level_id, -1) < Activity::MINIMUM_PASS_RESULT
            redirect_to build_script_level_path(sl)
            break
          end
          if sl.level_id == @script.script_levels.last.level_id
            # all levels complete - resume at first level
            redirect_to build_script_level_path(@script.script_levels.first)
          end
        end
      end
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
