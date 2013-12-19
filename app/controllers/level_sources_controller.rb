require 'image_lib'

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
    if @level_source.image.nil?
      request.protocol + request.host_with_port + ActionController::Base.helpers.asset_path('sharing_drawing.png')
    else
      url_for(:controller => "level_sources", :action => "generate_image", :id => params[:id], only_path: false)
    end
  end

  def generate_image
    background_url = 'app/assets/images/blank_sharing_drawing.png'
    level_source = LevelSource.find(params[:id])
    drawing_blob = level_source.image
    drawing_on_background = ImageLib::overlay_image(:background_url => background_url, :foreground_blob => drawing_blob)
    send_data drawing_on_background.to_blob, :stream => 'false', :type => 'image/png', :disposition => 'inline'
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
