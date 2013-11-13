class ActivitiesController < ApplicationController
  include LevelsHelper
  include ApplicationHelper

  protect_from_forgery except: :milestone
  check_authorization except: [:milestone]
  load_and_authorize_resource except: [:milestone]

  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def milestone_logger
    @@milestone_logger ||= Logger.new("#{Rails.root}/log/milestone.log")
  end

  def milestone
    solved = 'true' == params[:result]
    test_result = params[:testResult].to_i
    lines = params[:lines].to_i
    script_level = ScriptLevel.find(params[:script_level_id], include: [:script, :level])
    level = script_level.level
    trophy_updates = []
    level_source = LevelSource.lookup(level, params[:program])

    log_string = "Milestone Report:"
    log_string += "\t#{(current_user ? current_user.id.to_s : ("s:" + session.id))}"
    log_string += "\t#{request.remote_ip}"
    log_string += "\t#{params[:app]}"
    log_string += "\t#{params[:level]}"
    log_string += "\t#{params[:result]}"
    log_string += "\t#{params[:testResult]}"
    log_string += "\t#{params[:time]}"
    log_string += "\t#{params[:attempt]}"
    log_string += "\t#{params[:lines]}"
    log_string += "\t#{level_source.id.to_s}"
    log_string += "\t#{request.user_agent}"
    
    milestone_logger.info log_string

    if current_user
      authorize! :create, Activity
      authorize! :create, UserLevel

      Activity.create!(
          user: current_user,
          level: level,
          action: solved,
          test_result: test_result,
          attempt: params[:attempt].to_i,
          lines: lines,
          time: params[:time].to_i,
          level_source: level_source )

      user_level = UserLevel.where(user: current_user, level: level).first_or_create
      user_level.attempts += 1 unless user_level.best?
      user_level.best_result = user_level.best_result ?
          [test_result, user_level.best_result].max :
          test_result
      user_level.save!

      if lines > 0 && test_result >= Activity::MINIMUM_PASS_RESULT
        current_user.total_lines += lines
        current_user.save!
      end

      total_lines = current_user.total_lines

      begin
        trophy_updates = trophy_check(current_user)
      rescue Exception => e
        Rails.logger.error "Error updating trophy exception: #{e.inspect}"
      end
    else
      session_progress = session[:progress] || {}

      if test_result > session_progress.fetch(level.id, -1)
        session_progress[level.id] = test_result
        session[:progress] = session_progress
      end

      total_lines = session[:lines] || 0

      if lines > 0 && test_result >= Activity::MINIMUM_PASS_RESULT
        total_lines += lines
        session[:lines] = total_lines
      end
    end

    response = {}
    # figure out the previous level
    previous_level = script_level.previous_level
    if previous_level
      response[:previous_level] = build_script_level_path(previous_level)
    end

    # if they solved it, figure out next level
    if solved
      response[:total_lines] = total_lines

      if (trophy_updates.length > 0)
        response[:trophy_updates] = trophy_updates
      end

      next_level = script_level.next_level
      # If this is the end of the current script
      if !next_level
        # If the current script is hour of code, continue on to twenty-hour
        if script_level.script.hoc?
          next_level = ScriptLevel.find_by_script_id_and_chapter(Script.find_twenty_hour_script.id, script_level.chapter + 1)
          redirect = current_user ? build_script_level_path(next_level) : "http://code.org/api/hour/finish"
        end
        # Get the wrap up video
        video = script_level.script.wrapup_video
        response[:video_info] = { src: youtube_url(video.youtube_code),  key: video.key, name: data_t('video.name', video.key), redirect: redirect} if video
        response[:message] = 'no more levels'
      end
      # Get the next_level setup
      if next_level
        response[:redirect] = build_script_level_path(next_level)

        if (level.game_id != next_level.level.game_id)
          response[:stage_changing] = {
              previous: { number: level.game_id, name: level.game.name },
              new: { number: next_level.level.game_id, name: next_level.level.game.name }
          }
        end

        if (level.skin != next_level.level.skin)
          response[:skin_changing] = { previous: level.skin,
            new: next_level.level.skin }
        end
      end
      render json: response
    else
      response[:message] = 'try again'
      render json: response
    end
  end

  # GET /activities
  # GET /activities.json
  def index
    @activities = Activity.all
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: I18n.t('crud.created', model: Activity.model_name.human) }
        format.json { render action: 'show', status: :created, location: @activity }
      else
        format.html { render action: 'new' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: I18n.t('crud.updated', model: Activity.model_name.human) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url }
      format.json { head :no_content }
    end
  end

  def trophy_check(user)
    trophy_updates = []
    # called after a new activity is logged to assign any appropriate trophies
    current_trophies = user.user_trophies.includes([:trophy, :concept]).index_by { |ut| ut.concept }
    progress = user.concept_progress

    progress.each_pair do |concept, counts|
      current = current_trophies[concept]
      pct = counts[:current].to_f/counts[:max]

      new_trophy = Trophy.find_by_id case
        when pct == Trophy::GOLD_THRESHOLD
          Trophy::GOLD
        when pct >= Trophy::SILVER_THRESHOLD
          Trophy::SILVER
        when pct >= Trophy::BRONZE_THRESHOLD
          Trophy::BRONZE
        else
          # "no trophy earned"
      end

      if new_trophy
        if new_trophy.id == current.try(:trophy_id)
          # they already have the right trophy
        elsif current
          current.update_attributes!(trophy_id: new_trophy.id)
          trophy_updates << [data_t('concept.description', concept.name), new_trophy.name, view_context.image_path(new_trophy.image_name)]
        else
          UserTrophy.create!(user: user, trophy_id: new_trophy.id, concept: concept)
          trophy_updates << [data_t('concept.description', concept.name), new_trophy.name, view_context.image_path(new_trophy.image_name)]
        end
      end
    end

    trophy_updates
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_activity
    @activity = Activity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def activity_params
    params[:activity]
  end
end
