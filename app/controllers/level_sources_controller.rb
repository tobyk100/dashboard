class LevelSourcesController < ApplicationController
  include LevelsHelper

  def show(hide_source=true)
    @level_source = LevelSource.find(params[:id])
    @start_blocks = @level_source.data
    @level = @level_source.level
    @game = @level.game
    @full_width = true
    @hide_source = hide_source
    @share = true
  end

  def edit
    # currently edit is the same as show...
    show false
    render "show"
  end
end
