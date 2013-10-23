class SectionsController < ApplicationController
  before_filter :authenticate_user!
  check_authorization
  load_and_authorize_resource

  before_action :set_section, only: [:edit, :update, :destroy]

  def new
    @section = Section.new
  end

  def edit
  end

  def create
    @section = Section.new(section_params)
    @section.user = current_user

    respond_to do |format|
      if @section.save
        format.html { redirect_to manage_followers_path, notice: 'Section was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to manage_followers_path, notice: 'Section was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_url }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_section
    @section = Game.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def section_params
    params.require(:section).permit(:name, :base_url)
  end

  # this is to fix a ForbiddenAttributesError cancan issue
  prepend_before_filter do
    params[:section] &&= section_params
  end
end
