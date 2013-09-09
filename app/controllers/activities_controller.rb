class ActivitiesController < ApplicationController
  protect_from_forgery except: :milestone
  check_authorization except: [:milestone]
  load_and_authorize_resource except: [:milestone]

  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def milestone
    solved = 'true' == params[:result]
    script_level = ScriptLevel.find(params[:script_level_id], include: [:script, :level])
    level = script_level.level

    if current_user
      authorize! :create, Activity
      authorize! :create, UserLevel

      Activity.create!(
          user: current_user,
          level: level,
          action: solved,
          attempt: params[:attempt].to_i,
          time: params[:time].to_i,
          data: params[:program])

      user_level = UserLevel.find_or_create_by_user_id_and_level_id(current_user.id, level.id)
      user_level.attempts += 1
      # stars not passed yet, so faking it
      #user_level.stars = [params[:stars], user_level.stars].max
      user_level.stars = [solved ? (rand(3) + 1) : 0, user_level.stars.to_i].max
      user_level.save!
    end

    # if they solved it, figure out next level
    if solved
      next_level = ScriptLevel.find_by_script_id_and_chapter(script_level.script, script_level.chapter + 1)
      if next_level
        render json: { redirect: script_level_path(script_level.script, next_level) }
      else
        render json: { message: 'no more levels'}
      end
    else
      render json: { message: 'try again' }
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
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
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
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
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
