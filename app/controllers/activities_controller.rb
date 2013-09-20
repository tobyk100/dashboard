class ActivitiesController < ApplicationController
  include LevelsHelper
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

      begin
        self.class.trophy_check(current_user)
      rescue Exception => e
        Rails.logger.error "Error updating trophy exception: #{e.inspect}"
      end
    end

    # if they solved it, figure out next level
    if solved
      next_level = script_level.next_level
      if next_level
        render json: { redirect: script_level_url(next_level) }
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

  def self.trophy_check(user)
    # called after a new activity is logged to assign any appropriate trophies
    current_trophies = user.user_trophies.includes([:trophy, :concept]).index_by { |ut| ut.concept }
    progress = user.concept_progress

    progress.each_pair do |concept, counts|
      current = current_trophies[concept]
      pct = counts[:current].to_f/counts[:max]

      new_trophy = case
        when pct == 1
          Trophy::GOLD
        when pct >= 0.5
          Trophy::SILVER
        when pct >= 0.2
          Trophy::BRONZE
        else
          # "no trophy earned"
      end

      if new_trophy
        if new_trophy == current.try(:trophy_id)
          # they already have the right trophy
        elsif current
          current.update_attributes!(trophy_id: new_trophy)
        else
          UserTrophy.create!(user: user, trophy_id: new_trophy, concept: concept)
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
end
