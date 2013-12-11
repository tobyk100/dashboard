class LevelSourcesController < ApplicationController
  include LevelsHelper

  def show
    @level_source = LevelSource.find(params[:id])
    @level = @level_source.level
    @game = @level.game
    @full_width = true
  end

  def edit
    # currently edit is the same as show...
    show
  end
end