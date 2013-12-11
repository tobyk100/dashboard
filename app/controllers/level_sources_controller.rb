class LevelSourcesController < ApplicationController
  include LevelsHelper

  def show
    @level_source = LevelSource.find(params[:id])
    @level = @level_source.level
    @game = @level.game
  end
end