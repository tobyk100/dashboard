require 'RMagick'
require 'open-uri'

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
    @level_source.image.nil? ?
        request.protocol + request.host_with_port + ActionController::Base.helpers.asset_path('sharing_drawing.png') :
        url_for(:controller => "level_sources", :action => "generate_image", :id => params[:id], only_path: false)
  end

  def generate_image
    level_source = LevelSource.find(params[:id])
    background = Magick::ImageList.new
    background_url = open(request.protocol + request.host_with_port + ActionController::Base.helpers.asset_path('blank_sharing_drawing.png'))
    background.from_blob(background_url.read)
    drawing = Magick::ImageList.new
    drawing.from_blob(level_source.image)
    background.gravity = Magick::CenterGravity
    background.geometry = '154x154+0+20'
    drawing_on_background = background.composite_layers(drawing, Magick::OverCompositeOp)
    drawing_on_background.format = 'png'
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
