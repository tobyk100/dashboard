class LevelSourcesController < ApplicationController
  include LevelsHelper
  helper_method :show_image

  def show
    common(true)
  end

  def edit
    common(false)
    # currently edit is the same as show...
    render "show"
  end

  def show_image
    @level_source = LevelSource.find(params[:id])
    @level_source.image.nil? ? ActionController::Base.helpers.asset_url('sharing_drawing.png') : url_for(:controller => "level_sources", :action => "generate_image", :id => params[:id], only_path: false)
  end

  def generate_image
    @level_source = LevelSource.find(params[:id])
    send_data @level_source.image, :type => 'image/png', :disposition => 'inline'
  end

  protected
  def common(hide_source)
    @level_source = LevelSource.find(params[:id])
    @start_blocks = @level_source.data
    @level = @level_source.level
    @game = @level.game
    @full_width = true
    @hide_source = hide_source
    @share = true
  end
end
