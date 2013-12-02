class ActivitiesController < ApplicationController
  include LevelsHelper

  protect_from_forgery except: :milestone
  check_authorization except: [:milestone]
  load_and_authorize_resource except: [:milestone]
  before_filter :nonminimal, :only => :milestone

  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def milestone_logger
    @@milestone_logger ||= Logger.new("#{Rails.root}/log/milestone.log")
  end

  def milestone
    solved = 'true' == params[:result]
    total_lines = 0
    trophy_updates = []
    test_result = params[:testResult].to_i
    lines = params[:lines].to_i
    script_level = ScriptLevel.find(params[:script_level_id], include: [:script, :level])
    level = script_level.level

    if params[:program]
      level_source = LevelSource.lookup(level, params[:program])
    end

    log_milestone(level_source, params)

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

      if trophy_updates.length > 0
        prize_check(current_user)
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

    render json: milestone_response(script_level: script_level,
                                    total_lines: total_lines,
                                    trophy_updates: trophy_updates,
                                    solved?: solved)
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

  def prize_check(user)
    if user.trophy_count == (Concept.cached.length * Trophy::TROPHIES_PER_CONCEPT)
      if !user.prize_earned
        # send e-mail
        PrizeMailer.prize_earned(user).deliver
        user.prize_earned = true
        user.save!
      end

      # for awarding prizes, we only honor the first (primary) teacher
      teacher = user.teachers.first

      if teacher && (!teacher.teacher_prize_earned || !teacher.teacher_bonus_prize_earned)
        t_prize, t_bonus = teacher.check_teacher_prize_eligibility
        if t_prize && !teacher.teacher_prize_earned
          # send e-mail
          PrizeMailer.teacher_prize_earned(teacher).deliver
          teacher.teacher_prize_earned = true
          teacher.save!
        end

        if t_bonus && !teacher.teacher_bonus_prize_earned
          # send e-mail
          PrizeMailer.teacher_bonus_prize_earned(teacher).deliver
          teacher.teacher_bonus_prize_earned = true
          teacher.save!
        end
      end
    end
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

  def log_milestone(level_source, params)
    log_string = "Milestone Report:"
    if (current_user || session.id)
      log_string += "\t#{(current_user ? current_user.id.to_s : ("s:" + session.id))}"
    else
      log_string += "\tanon"
    end
    log_string += "\t#{request.remote_ip}\t#{params[:app]}\t#{params[:level]}\t#{params[:result]}" +
                  "\t#{params[:testResult]}\t#{params[:time]}\t#{params[:attempt]}\t#{params[:lines]}"
    log_string += level_source.present? ? "\t#{level_source.id.to_s}" : "\t"
    log_string += "\t#{request.user_agent}"

    milestone_logger.info log_string
  end
end
