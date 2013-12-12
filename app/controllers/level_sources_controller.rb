class LevelSourcesController < ApplicationController
  include LevelsHelper

  def show
    common(true)
  end

  def edit
    common(false)
    # currently edit is the same as show...
    render "show"
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
