class PrizeProvidersController < ApplicationController
  before_filter :authenticate_user!
  check_authorization
  load_and_authorize_resource
  
  before_action :set_prize_provider, only: [:show, :edit, :update, :destroy, :claim_prize]

  # GET /prize_providers
  # GET /prize_providers.json
  def index
    @prize_providers = PrizeProvider.all
  end

  # GET /prize_providers/1
  # GET /prize_providers/1.json
  def show
  end

  # GET /prize_providers/new
  def new
    @prize_provider = PrizeProvider.new
  end

  # GET /prize_providers/1/claim_prize
  def claim_prize
    raise 'no prize_provider' if !@prize_provider.present?
    raise 'type parameter missing' if !params[:type].present?
    # confirm that user is in the US here
    us_user = true if request.location.country_code == 'US'
    if us_user
      prize = case params[:type].downcase
      when 'teacher'
        TeacherPrize.assign_to_user(current_user, @prize_provider)
        # e-mail confirmation with code?
        # PrizeMailer.prize_redeemed(user).deliver
      when 'teacher_bonus'
        TeacherBonusPrize.assign_to_user(current_user, @prize_provider)
        # e-mail confirmation with code?
        # PrizeMailer.teacher_prize_redeemed(user).deliver
      when 'student'
        Prize.assign_to_user(current_user, @prize_provider)
        # e-mail confirmation with code?
        # PrizeMailer.teacher_bonus_prize_redeemed(user).deliver
      else
        raise 'type parameter missing'
      end
    end

    if prize.present?
      redirect_to my_prizes_url, notice: t('redeem_prizes.success')
    elsif !us_user
      redirect_to my_prizes_url, alert: t('redeem_prizes.error_us_only')
    else
      redirect_to my_prizes_url, alert: t('redeem_prizes.error')
    end
  end

  # GET /prize_providers/1/edit
  def edit
  end

  # POST /prize_providers
  # POST /prize_providers.json
  def create
    @prize_provider = PrizeProvider.new(prize_provider_params)

    respond_to do |format|
      if @prize_provider.save
        format.html { redirect_to @prize_provider, notice: 'Prize provider was successfully created.' }
        format.json { render action: 'show', status: :created, location: @prize_provider }
      else
        format.html { render action: 'new' }
        format.json { render json: @prize_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prize_providers/1
  # PATCH/PUT /prize_providers/1.json
  def update
    respond_to do |format|
      if @prize_provider.update(prize_provider_params)
        format.html { redirect_to @prize_provider, notice: 'Prize provider was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @prize_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prize_providers/1
  # DELETE /prize_providers/1.json
  def destroy
    @prize_provider.destroy
    respond_to do |format|
      format.html { redirect_to prize_providers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prize_provider
      @prize_provider = PrizeProvider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prize_provider_params
      params.require(:prize_provider).permit(:name, :url, :description_token, :image_name, :type)
    end
    
    # this is to fix a ForbiddenAttributesError cancan issue
    prepend_before_filter do
      params[:prize_provider] &&= prize_provider_params
    end
end
