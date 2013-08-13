class ConceptsController < ApplicationController
  check_authorization
  load_and_authorize_resource

  before_action :set_concept, only: [:show, :edit, :update, :destroy]

  # GET /concepts
  # GET /concepts.json
  def index
    @concepts = Concept.all
  end

  # GET /concepts/1
  # GET /concepts/1.json
  def show
  end

  # GET /concepts/new
  def new
    @concept = Concept.new
  end

  # GET /concepts/1/edit
  def edit
  end

  # POST /concepts
  # POST /concepts.json
  def create
    @concept = Concept.new(concept_params)

    respond_to do |format|
      if @concept.save
        format.html { redirect_to @concept, notice: 'Concept was successfully created.' }
        format.json { render action: 'show', status: :created, location: @concept }
      else
        format.html { render action: 'new' }
        format.json { render json: @concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /concepts/1
  # PATCH/PUT /concepts/1.json
  def update
    respond_to do |format|
      if @concept.update(concept_params)
        format.html { redirect_to @concept, notice: 'Concept was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /concepts/1
  # DELETE /concepts/1.json
  def destroy
    @concept.destroy
    respond_to do |format|
      format.html { redirect_to concepts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #def set_concept
    #  @concept = Concept.find(params[:id])
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concept_params
      params.require(:concept).permit(:name)
    end
end
